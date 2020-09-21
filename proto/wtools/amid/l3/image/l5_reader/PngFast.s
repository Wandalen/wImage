( function _PngFast_s_()
{

'use strict';

/**
 * @classdesc Abstract interface to read image.
 * @class wImageReaderPngFast
 * @namespace wTools
 * @module Tools/mid/ImageReader
 */

let _ = _global_.wTools;
let { decode } = require( 'fast-png' );
let Backend = { decode };
let bufferFromStream = require( './BufferFromStream.s' );
let Parent = _.image.reader.Abstract;
let Self = wImageReaderPngFast;
function wImageReaderPngFast()
{

  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'PngFast';

// --
// implementation
// --

function _structureHandle( o )
{
  let self = this;
  let os = o.originalStructure;
  // console.log( 'OS: ', os )
  if( os === null )
  os = o.op.originalStructure;

  // logger.log( '_structureHandle', o.mode );
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

  o.op.params.originalStructure = os;

  if( os.channels === 3 )
  {
    _.assert( structure.channelsArray.length === 0 );
    channelAdd( 'red' );
    channelAdd( 'green' );
    channelAdd( 'blue' );
  }
  else if( os.channels === 4 )
  {
    _.assert( structure.channelsArray.length === 0 );
    channelAdd( 'red' );
    channelAdd( 'green' );
    channelAdd( 'blue' );
    channelAdd( 'alpha' );
  }

  if( os.channels === 1 )
  {
    _.assert( structure.channelsArray.length === 0 );
    channelAdd( 'gray' );
  }
  else if( os.channels === 2 )
  {
    _.assert( structure.channelsArray.length === 0 );
    channelAdd( 'gray' );
    channelAdd( 'alpha' );
  }

  // structure.bitsPerPixel = os.depth;
  structure.bitsPerPixel = _.mapVals( structure.channelsMap ).reduce( ( val, channel ) => val + channel.bits, 0 );
  structure.bytesPerPixel = Math.round( structure.bitsPerPixel / 8 );
  // NO INFO ABOUT INTELACING
  // structure.special.interlaced = ;
  structure.hasPalette = os.palette !== undefined;

  o.op.params.headGot = true;

  if( o.op.params.onHead )
  o.op.params.onHead( o.op );

  return o.op;

  /* */

  function channelAdd( name )
  {
    // temp
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
  ... Parent.prototype._read.defaults,
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
    return self._readGeneralStreamSync( o )
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
  // mode : 'full',
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
    let image = Backend.decode( _.bufferNodeFrom( o.in.data ) );
    self._structureHandle({ originalStructure : image, op : o, mode : 'full' });
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
    let image = Backend.decode( _.bufferNodeFrom( o.in.data ) );
    self._structureHandle({ originalStructure : image, op : o, mode : 'full' });
    ready.take( o );
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

let Formats = [ 'png' ];
let Exts = [ 'png' ];

let Composes =
{
  shortName : 'pngFast',
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
  SupportsDimensions : 1,
  SupportsBuffer : 1,
  SupportsDepth : 1,
  SupportsColor : 1,
  SupportsSpecial : 0,
  LimitationsRead : 1,
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
_.assert( !_.image.reader[ Self.shortName ] );
new Self();
_.assert( !!_.image.reader[ Self.shortName ] );
// _.image.reader[ Self.shortName ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
