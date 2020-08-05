( function _PngJpegjs_s_()
{

'use strict';

/**
 * @classdesc Abstract interface to read image.
 * @class wImageReaderPngLwipjs
 * @namespace wTools
 * @module Tools/mid/ImageReader
 */

let _ = _global_.wTools;
let Backend = require( 'jpeg-js' );
let Parent = _.image.reader.Abstract;
let bufferFromStream = require( './BufferFromStream.s' );
let Self = wImageReaderJpegjs;
function wImageReaderJpegjs()
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Jpegjs';

// --
// implementation
// --

function _structureHandle( o )
{
  let self = this;
  let os = o.originalStructure;
  if( os === null )
  os = o.op.originalStructure;
  console.log( os )
  // logger.log( '_structureHandle', o.mode );
  _.assertRoutineOptions( _structureHandle, arguments );
  _.assert( _.objectIs( os ) );

  if( o.mode === 'full' && o.op.mode === 'full' )
  o.op.structure.buffer = _.bufferRawFrom( os.data );
  else
  o.op.structure.buffer = null;

  if( o.op.headGot )
  return o.op;

  o.op.structure.dims = [ os.width, os.height ];

  o.op.originalStructure = os;

  // _.assert( !os.palette, 'not implemented' );

  // if( os.colors === 3 )
  // {
  //   _.assert( o.op.structure.channelsArray.length === 0 );
  //   channelAdd( 'red' );
  //   channelAdd( 'green' );
  //   channelAdd( 'blue' );
  // }

  // if( os.colors === 4 )
  // {
  //   _.assert( o.op.structure.channelsArray.length === 0 );
  //   channelAdd( 'gray' );
  // }

  // if( os.hasAlphaChannel )
  // {
  //   channelAdd( 'alpha' );
  // }

  // o.op.structure.bitsPerPixel = _.mapVals( o.op.structure.channelsMap ).reduce( ( val, channel ) => val + channel.bits, 0 );
  // o.op.structure.bytesPerPixel = Math.round( o.op.structure.bitsPerPixel / 8 );
  // o.op.structure.bitsPerPixel = 8;
  // o.op.structure.bytesPerPixel = 1;

  // o.op.structure.special.interlaced = false;
  // o.op.structure.hasPalette = false;

  o.op.headGot = true;

  if( o.op.onHead )
  o.op.onHead( o.op );
  console.log( o.op.structure )
  return o.op;

  /* */

  // function channelAdd( name )
  // {
  //   o.op.structure.channelsMap[ name ] = { name, bits : 8, order : o.op.structure.channelsArray.length };
  //   o.op.structure.channelsArray.push( name );
  // }

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
  _.assert( _.longHas( [ 'full', 'head' ], o.mode ) );

  o.headGot = false;

  if( _.streamIs( o.data ) )
  if( o.sync )
  return self._readGeneralStreamSync( o );
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
    let os = Backend.decode( _.bufferNodeFrom( o.data ) );
    self._structureHandle({ originalStructure : os, op : o, mode : 'full' });
    return o;
  }
  catch( err )
  {
    throw _.err( err );
  }

}

//

function _readGeneralBufferAsync( o )
{
  let self = this;
  let ready = new _.Consequence();
  try
  {
    let os = Backend.decode( _.bufferNodeFrom( o.data ) );
    self._structureHandle({ originalStructure : os, op : o, mode : 'full' });
    ready.take( o );
  }
  catch( err )
  {
    throw _.err( err );
  }
  return ready;
}

//

function _readHead( o )
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

// --
// relations
// --

let Formats = [ 'jpg' ];
let Exts = [ 'jpg', 'jpeg' ];

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
  SupportsDimensions : 1,
  SupportsBuffer : 1,
  SupportsDepth : 0,
  SupportsColor : 0,
  SupportsSpecial : 0,
  LimitationsRead : 0,
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
  _readGeneralBufferAsync,
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
