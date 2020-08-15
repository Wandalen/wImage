( function _Pngjs_s_()
{

'use strict';

/**
 * @classdesc Abstract interface to read image.
 * @class wImageReaderPngjs
 * @namespace wTools
 * @module Tools/mid/ImageReader
 */

let _ = _global_.wTools;
let Backend = require( 'pngjs' );
let Parent = _.image.reader.Abstract;
let Self = wImageReaderPngjs;
function wImageReaderPngjs()
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Pngjs';

// --
// implementation
// --

function _structureHandle( o )
{
  let self = this;
  let os = o.originalStructure;

  if( os === null )
  os = o.op.originalStructure;

  _.assertRoutineOptions( _structureHandle, arguments );
  _.assert( _.objectIs( os ) );
  _.assert( _.strIs( o.mode ) );

  let structure = o.op.out.data;

  if( o.mode === 'full' && o.op.params.mode === 'full' )
  structure.buffer = _.bufferRawFrom( os.data );
  else
  structure.buffer = null;

  if( o.op.params.headGot )
  return o.op;

  structure.dims = [ os.width, os.height ];

  os = os._parser ? os._parser._metaData : os;

  o.op.params.originalStructure = os;

  _.assert( !os.palette, 'not implemented' );

  if( os.color )
  {
    _.assert( structure.channelsArray.length === 0 );
    channelAdd( 'red' );
    channelAdd( 'green' );
    channelAdd( 'blue' );
  }

  if( os.colorType === 4 )
  {
    _.assert( structure.channelsArray.length === 0 );
    channelAdd( 'gray' );
  }

  if( os.alpha )
  {
    channelAdd( 'alpha' );
  }

  structure.bytesPerPixel = os.bpp;
  structure.bitsPerPixel = _.mapVals( structure.channelsMap ).reduce( ( val, channel ) => val + channel.bits, 0 );

  structure.special.interlaced = os.interlace;
  structure.hasPalette = os.palette;

  o.op.params.headGot = true;
  if( o.op.params.onHead )
  o.op.params.onHead( o.op );

  return o.op;

  /* */

  function channelAdd( name )
  {
    structure.channelsMap[ name ] = { name, bits : os.depth, order : structure.channelsArray.length };
    structure.channelsArray.push( name );
  }

}

_structureHandle.defaults =
{
  op : null,
  originalStructure : null,
  mode : null,
}


//

function _readGeneral( o )
{
  let self = this;

  _.assertRoutineOptions( _readGeneral, o );
  _.assert( arguments.length === 1 );
  _.assert( _.longHas( [ 'full', 'head' ], o.params.mode ) );
  _.assert( o.in.format === null || _.strIs( o.in.format ) );
  _.assert( o.out.format === null || _.strIs( o.out.format ) );
  _.assert( o.in.data !== undefined );

  o.params.headGot = false;

  if( _.streamIs( o.in.data ) )
  {

    if( o.in.format === null )
    o.in.format = 'stream.png';

    if( o.sync )
    return self._readGeneralStreamSync( o );
    else
    return self._readGeneralStreamAsync( o );
  }
  else
  {

    if( o.in.format === null )
    o.in.format = 'buffer.png';

    if( o.sync )
    return self._readGeneralBufferSync( o );
    else
    return self._readGeneralBufferAsync( o );
  }

}

_readGeneral.defaults =
{
  ... Parent.prototype._read.defaults,
}

//

function _readGeneralStreamSync( o )
{
  let self = this;
  let ready = self._readGeneralStreamAsync( o );
  ready.deasync();
  return ready.sync();
}

//

function _readGeneralStreamAsync( o )
{
  let self = this;
  let ready = new _.Consequence();
  let backend = new Backend.PNG();
  let done;

  backend
  .on( 'error', ( err ) => errorHandle( err ) )
  .on( 'metadata', function ( os )
  {
    if( o.params.mode === 'head' )
    {
      o.in.data.close();
      backend._parser._paused = true;
      backend._parser._buffered = 0;
    }
    self._structureHandle({ originalStructure : os, op : o, mode : 'head' });
    if( o.params.mode === 'head' )
    {
      done = true;
      ready.take( o );
    }
  })
  .on( 'parsed', function ( data )
  {
    if( o.params.mode === 'head' )
    return;
    if( done )
    return;
    _.assert( !!o.params.headGot );
    o.params.originalStructure.data = data;
    self._structureHandle({ originalStructure : o.params.originalStructure, op : o, mode : 'full' });
    ready.take( o );
    done = true;
  })

  o.in.data.pipe( backend );

  return ready;

  function errorHandle( err )
  {
    debugger;
    if( o.params.headGot )
    return;
    if( done )
    return;
    err = _.err( err )
    done = err;
    ready.error( err );
  }
}

//

function _readGeneralBufferSync( o )
{
  let self = this;
  /* qqq : write proper code for mode : head */
  try
  {
    let os;
    os = Backend.PNG.sync.read( _.bufferNodeFrom( o.in.data ) );
    self._structureHandle({ originalStructure : os, op : o, mode : 'full' });
  }
  catch( err )
  {
    throw _.err( err );
  }
  return o;
}

//

function _readGeneralBufferAsync( o )
{
  let self = this;
  let ready = new _.Consequence();
  let backend = new Backend.PNG({})
  let done;

  backend
  .on( 'error', ( err ) => errorHandle( err ) )
  .on( 'metadata', ( os ) =>
  {
    if( o.params.mode === 'head' )
    {
      backend._parser._paused = true;
      backend._parser._buffered = 0;
    }
    self._structureHandle({ originalStructure : os, op : o, mode : 'head' });
    if( o.params.mode === 'head' )
    {
      ready.take( o );
      done = true;
    }
  })

  backend.parse( _.bufferNodeFrom( o.in.data ), ( err, os ) =>
  {
    debugger;
    if( err )
    return errorHandle( err );
    if( o.params.mode === 'head' )
    return;
    self._structureHandle({ originalStructure : os, op : o, mode : 'full' });
    ready.take( o );
    done = true;
  });

  return ready;

  function errorHandle( err )
  {
    if( o.headGot )
    return;
    if( done )
    return;
    err = _.err( err )
    done = err;
    ready.error( err );
  }
}

//

function _readHead( o )
{
  let self = this;
  _.assert( arguments.length === 1 );
  _.assertRoutineOptions( _readHead, o );
  debugger;
  if( !o.params.mode )
  o.params.mode = 'head';
  return self._readGeneral( o );
}

_readHead.defaults =
{
  ... Parent.prototype._readHead.defaults,
  // ... Parent.prototype._read.defaults,
}

// //
//
// function _read( o )
// {
//   let self = this;
//   _.assert( arguments.length === 1 );
//   _.assertRoutineOptions( _read, o );
//   o.params.mode = 'full';
//   return self._readGeneral( o );
// }
//
// _read.defaults =
// {
//   ... Parent.prototype._read.defaults,
// }

//

function _read( o )
{
  let self = this;
  _.assert( arguments.length === 1 );
  _.assertRoutineOptions( _read, o );
  if( !o.params.mode )
  o.params.mode = 'full';
  return self._readGeneral( o );
}

_read.defaults =
{
  ... Parent.prototype._read.defaults,
}

// --
// relations
// --

let Formats = [ 'png' ];
let Exts = [ 'png' ];

let Composes =
{

  shortName : 'pngjs',
  ext : _.define.own([ 'png' ]),
  inFormat : _.define.own([ 'buffer.any', 'string.any' ]),
  outFormat : _.define.own([ 'structure.image' ]),
  feature : _.define.own({}),

}

let Aggregates =
{
}

let Associates =
{
}

let Restricts =
{
}

let Statics =
{
  Formats,
  Exts,
  SupportsStream : 0,
  SupportsAsync : 1,
  SupportsSync : 1,
  SupportsReadHead : 1
}

let Forbids =
{
}

let Accessors =
{
}

let Medials =
{
}

// --
// prototype
// --

let Extension =
{

  _structureHandle,
  _readGeneralStreamSync,
  _readGeneralStreamAsync,
  _readGeneralBufferSync,
  // _readGeneralBufferSync2,
  _readGeneralBufferAsync,
  _readGeneral,

  _readHead,
  _read,
  // _read2,

  //

  Formats,
  Exts,

  //

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Medials,
  Statics,
  Forbids,
  Accessors,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Extension,
});

//

_.assert( !_.image.reader[ Self.shortName ] );
new Self();
_.assert( !!_.image.reader[ Self.shortName ] );

// _.image.reader[ Self.shortName ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
