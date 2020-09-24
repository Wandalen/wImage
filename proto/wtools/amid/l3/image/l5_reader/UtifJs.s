( function _UtifJs_s_()
{

'use strict';

/**
 * @classdesc Abstract interface to read image.
 * @class wImageReaderUtifJs
 * @namespace wTools
 * @module Tools/mid/ImageReader
 */

let _ = _global_.wTools;
let Backend = require( 'utif' );
let bufferFromStream = require( './BufferFromStream.s' );
let Parent = _.image.reader.Abstract;
let Self = wImageReaderUtifJs;
function wImageReaderUtifJs()
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'UtifJs';

// --
// implementation
// --

function _structureHandle( o )
{
  let self = this;
  let os = o.originalStructure;

  if( os === null )
  os = o.op.originalStructure;

  // console.log( os )
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

  structure.dims = [ os.t256[ 0 ], os.t257[ 0 ] ];

  o.op.params.originalStructure = os;

  if( os.t262[ 0 ] === 3 )
  structure.hasPalette = true;
  else
  structure.hasPalette = false;

  if( os.t262[ 0 ] === 2 )
  {
    _.assert( structure.channelsArray.length === 0 );
    channelAdd( 'red' );
    channelAdd( 'green' );
    channelAdd( 'blue' );
  }

  if( os.t262[ 0 ] === 0 || os.t262[ 0 ] === 1 )
  {
    _.assert( structure.channelsArray.length === 0 );
    channelAdd( 'gray' );
  }

  structure.bitsPerPixel = os.t258.reduce( ( a, b ) => a + b, 0 );
  structure.bytesPerPixel = Math.ceil( structure.bitsPerPixel / 8 );
  structure.special.compression = os.t259[ 0 ] !== 1;

  o.op.params.headGot = true;

  if( o.op.params.onHead )
  o.op.params.onHead( o.op );
  // console.log( 'Structure; ', o.op )
  return o.op;

  /* */

  function channelAdd( name )
  {
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

//

function _readHead ( o )
{
  let self = this;
  _.assert( arguments.length === 1 );
  _.assertRoutineOptions( _readHead, o );
  if( !o.params.mode )
  o.params.mode = 'head';
  return self._readGeneral( o );
}

_readHead.defaults =
{
  ... Parent.prototype._readHead.defaults,
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
    o.in.format = 'stream.tif';

    if( o.sync )
    return self._readGeneralStreamSync( o );
    else
    return self._readGeneralStreamAsync( o );
  }
  else
  {

    if( o.in.format === null )
    o.in.format = 'buffer.tif';

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

function _readGeneralStreamAsync( o )
{
  let self = this;
  let ready = bufferFromStream({ src : o.in.data });

  ready.then( ( buffer ) =>
  {
    o.in.data = _.bufferNodeFrom( buffer );
    return self._readGeneralBufferAsync( o );
  } )

  return ready;
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

function _readGeneralBufferSync( o )
{
  let self = this;
  try
  {
    let ifds = Backend.decode( _.bufferNodeFrom( o.in.data ) );
    if( o.mode === 'head' )
    {
      self._structureHandle({ originalStructure : ifds[ 0 ], op : o, mode : 'head' });
    }
    else
    {
      Backend.decodeImage( _.bufferNodeFrom( o.in.data ), ifds[ 0 ] )
      self._structureHandle({ originalStructure : ifds[ 0 ], op : o, mode : 'full' });
    }
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
  try
  {
    let ifds = Backend.decode( _.bufferNodeFrom( o.in.data ) );
    if( o.mode === 'head' )
    {
      self._structureHandle({ originalStructure : ifds[ 0 ], op : o, mode : 'head' });
      ready.take( o );
    }
    else
    {
      Backend.decodeImage( _.bufferNodeFrom( o.in.data ), ifds[ 0 ] )
      self._structureHandle({ originalStructure : ifds[ 0 ], op : o, mode : 'full' });
      ready.take( o );
    }
  }
  catch( err )
  {
    throw _.err( err );
  }

  return ready;
}


// --
// relations
// --

let Formats = [ 'tif' ];
let Exts = [ 'tif', 'tiff' ];

let Composes =
{
  shortName : 'utifJs',
  ext : _.define.own([ 'tif' ]),
  inFormat : _.define.own([ 'buffer.any', 'string.any' ]),
  outFormat : _.define.own([ 'structure.image' ]),
  feature : _.define.own({ default : 1 }),
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
  SupportsDimensions : 1,
  SupportsBuffer : 1,
  SupportsDepth : 1,
  SupportsColor : 1,
  SupportsSpecial : 1,
  LimitationsRead : 0,
  MethodsNativeCount : 1
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
  _readGeneralBufferSync,
  _readGeneralBufferAsync,
  _readGeneralStreamAsync,
  _readGeneralStreamSync,
  _readGeneral,

  _read,
  _readHead,

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
