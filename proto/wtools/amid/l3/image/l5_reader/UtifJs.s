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

  // logger.log( '_structureHandle', o.mode );
  _.assertRoutineOptions( _structureHandle, arguments );
  _.assert( _.objectIs( os ) );

  if( o.mode === 'full' && o.op.mode === 'full' )
  o.op.structure.buffer = _.bufferRawFrom( os.data );
  else
  o.op.structure.buffer = null;

  if( o.op.headGot )
  return o.op;

  o.op.structure.dims = [ os.t256[ 0 ], os.t257[ 0 ] ];

  o.op.originalStructure = os;

  // if( os.t262[ 0 ] === 3 )
  // o.op.structure.colors = 'palette';
  // else if( os.t262[ 0 ] === 0 || os.t262[ 0 ] === 1 )
  // o.op.structure.colors = 'gray';
  // else
  // o.op.structure.colors = 'rgb';

  if( os.t262[ 0 ] === 2 )
  {
    _.assert( o.op.structure.channelsArray.length === 0 );
    channelAdd( 'red' );
    channelAdd( 'green' );
    channelAdd( 'blue' );
  }

  if( os.t262[ 0 ] === 0 || os.t262[ 0 ] === 1 )
  {
    _.assert( o.op.structure.channelsArray.length === 0 );
    channelAdd( 'gray' );
  }

  o.op.structure.bitsPerPixel = os.t258.reduce( ( a, b ) => a + b, 0 );
  o.op.structure.special.compression = os.t259[ 0 ] !== 1;

  o.op.headGot = true;

  if( o.op.onHead )
  o.op.onHead( o.op );
  console.log( 'Structure; ', o.op.structure )
  return o.op;

  /* */

  function channelAdd( name )
  {
    o.op.structure.channelsArray.push( name );
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
  o.mode = 'full';
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
  o.mode = 'head';
  return self._readGeneral( o );
}

_readHead.defaults =
{
  ... Parent.prototype._read.defaults,
}

//

function _readGeneral( o )
{
  let self = this;

  _.assertRoutineOptions( _readGeneral, o );
  _.assert( arguments.length === 1 );
  _.assert( _.longHas( [ 'full', 'head' ], o.mode ) );

  o.headGot = false;

  if( _.streamIs( o.data ) )
  if( o.sync )
  return self._readGeneralStreamSync( o )
  else
  return self._readGeneralStreamAsync( o );

  if( o.sync )
  return self._readGeneralBufferSync( o );
  else
  return self._readGeneralBufferAsync( o );

}

_readGeneral.defaults =
{
  ... Parent.prototype._read.defaults,
  mode : 'full',
}

//

function _readGeneralStreamAsync( o )
{
  let self = this;
  let ready = bufferFromStream({ src : o.data });

  ready.then( ( buffer ) =>
  {
    o.data = _.bufferNodeFrom( buffer );
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
    let ifds = Backend.decode( _.bufferNodeFrom( o.data ) );
    if( o.mode === 'head' )
    {
      self._structureHandle({ originalStructure : ifds[ 0 ], op : o, mode : 'head' });
    }
    else
    {
      Backend.decodeImage( _.bufferNodeFrom( o.data ), ifds[ 0 ] )
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
    let ifds = Backend.decode( _.bufferNodeFrom( o.data ) );
    if( o.mode === 'head' )
    {
      self._structureHandle({ originalStructure : ifds[ 0 ], op : o, mode : 'head' });
      ready.take( o );
    }
    else
    {
      Backend.decodeImage( _.bufferNodeFrom( o.data ), ifds[ 0 ] )
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
  SupportsAsync : 0,
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
  _readGeneralBufferSync,
  _readGeneralBufferAsync,
  _readGeneralStreamAsync,
  _readGeneralStreamSync,
  _readGeneral,

  _readHead,
  _read,

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

_.image.reader[ Self.shortName ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
