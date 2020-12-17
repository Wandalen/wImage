( function _PngOmggif_s_()
{

'use strict';

/**
 * @classdesc Abstract interface to read image.
 * @class wImageReaderOmggif
 * @namespace wTools
 * @module Tools/mid/ImageReader
 */

let _ = _global_.wTools;
let Backend = require( 'omggif' );
let bufferFromStream = require( './BufferFromStream.s' );
let Parent = _.image.reader.Abstract;
let Self = wImageReaderOmggif;
function wImageReaderOmggif()
{

  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Omggif';

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
  console.log( os )
  _.assertRoutineOptions( _structureHandle, arguments );
  _.assert( _.objectIs( os ) );
  _.assert( _.strIs( o.mode ) );

  let structure = o.op.out.data;

  if( o.mode === 'full' && o.op.params.mode === 'full' )
  structure.buffer = _.bufferRawFrom( os.buffer );
  else
  structure.buffer = null;

  if( o.op.params.headGot )
  return o.op;

  structure.dims = [ os.metadata.width, os.metadata.height ];

  o.op.params.originalStructure = os;

  // _.assert( !os.palette, 'not implemented' );

  // if( os.colorType === 'rgb' )
  // {
  //   _.assert( structure.channelsArray.length === 0 );
  //   channelAdd( 'red' );
  //   channelAdd( 'green' );
  //   channelAdd( 'blue' );
  // }
  // else if( os.colorType === 'rgba' )
  // {
  //   _.assert( structure.channelsArray.length === 0 );
  //   channelAdd( 'red' );
  //   channelAdd( 'green' );
  //   channelAdd( 'blue' );
  //   channelAdd( 'alpha' );
  // }

  // if( os.colorType === 'gray-scale' )
  // {
  //   _.assert( structure.channelsArray.length === 0 );
  //   channelAdd( 'gray' );
  // }

  // structure.bitsPerPixel = _.mapVals( structure.channelsMap ).reduce( ( val, channel ) => val + channel.bits, 0 );
  // structure.bytesPerPixel = Math.round( structure.bitsPerPixel / 8 );
  // structure.bitsPerPixel = os.bitDepth;
  structure.special.interlaced = os.metadata.interlaced;
  structure.special.transparentIndex = os.metadata.transparent_index;
  structure.hasPalette = os.metadata.has_local_palette;

  o.op.params.headGot = true;

  if( o.op.params.onHead )
  o.op.params.onHead( o.op );

  return o.op;

  /* */

  function channelAdd( name )
  {
    // structure.channelsMap[ name ] = { name, bits : os.bitDepth, order : structure.channelsArray.length };
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
    o.in.format = 'stream.gif';

    if( o.sync )
    return self._readGeneralStreamSync( o );
    else
    return self._readGeneralStreamAsync( o );
  }
  else
  {

    if( o.in.format === null )
    o.in.format = 'buffer.gif';

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
  let structure = {}
  try
  {
    let buff = _.bufferNodeFrom( o.in.data )
    let image = new Backend.GifReader( buff );
    structure.metadata = image.frameInfo( 0 );
    if( o.mode === 'head' )
    {
      self._structureHandle({ originalStructure : structure, op : o, mode : 'head' });
    }
    else
    {
      structure.buffer = buff.slice
      (
        structure.metadata.data_offset,
        structure.metadata.data_offset + structure.metadata.data_length
      )
      self._structureHandle({ originalStructure : structure, op : o, mode : 'full' });
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
  let structure = {};

  try
  {
    let buff = _.bufferNodeFrom( o.in.data )
    let image = new Backend.GifReader( buff );
    structure.metadata = image.frameInfo( 0 );
    if( o.mode === 'head' )
    {
      self._structureHandle({ originalStructure : structure, op : o, mode : 'head' });
      ready.take( o );
    }
    else
    {
      structure.buffer = buff.slice
      (
        structure.metadata.data_offset,
        structure.metadata.data_offset + structure.metadata.data_length
      )
      self._structureHandle({ originalStructure : structure, op : o, mode : 'full' });
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

let Formats = [ 'gif' ];
let Exts = [ 'gif' ];

let Composes =
{
  shortName : 'omggif',
  ext : _.define.own([ 'gif' ]),
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
  SupportsBuffer : 0,
  SupportsDepth : 1,
  SupportsColor : 0,
  SupportsSpecial : 1,
  LimitationsRead : 0,
  MethodsNativeCount : 1,
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
