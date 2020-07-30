( function _PngSharp_s_()
{

'use strict';

/**
 * @classdesc Abstract interface to read image.
 * @class wImageReaderPngjs
 * @namespace wTools
 * @module Tools/mid/ImageReader
 */

let _ = _global_.wTools;
let Backend = require( 'sharp' );
let Parent = _.image.reader.Abstract;
let bufferFromStream = require( './BufferFromStream.s' );
let Self = wImageReaderPngSharp;
function wImageReaderPngSharp()
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'PngSharp';

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
  // console.log( os );
  _.assertRoutineOptions( _structureHandle, arguments );
  _.assert( _.objectIs( os ) );

  if( o.mode === 'full' && o.op.mode === 'full' )
  o.op.structure.buffer = _.bufferRawFrom( os.buffer );
  else
  o.op.structure.buffer = null;

  if( o.op.headGot )
  return o.op;

  o.op.structure.dims = [ os.metadata.width, os.metadata.height ];

  o.op.originalStructure = os;

  _.assert( !os.metadata.palette, 'not implemented' );

  if( os.metadata.space === 'rgb' || os.metadata.space === 'srgb' )
  {
    _.assert( o.op.structure.channelsArray.length === 0 );
    channelAdd( 'red' );
    channelAdd( 'green' );
    channelAdd( 'blue' );
  }

  if( os.metadata.space === 'gray' )
  {
    _.assert( o.op.structure.channelsArray.length === 0 );
    channelAdd( 'gray' );
  }

  if( os.metadata.hasAlpha )
  {
    channelAdd( 'alpha' );
  }

  // o.op.structure.bitsPerPixel = _.mapVals( o.op.structure.channelsMap ).reduce( ( val, channel ) => val + channel.bits, 0 );
  // o.op.structure.bytesPerPixel = Math.round( o.op.structure.bitsPerPixel / 8 );
  // NO BIT DEPTH
  o.op.structure.bitsPerPixel = 8;
  o.op.structure.special.interlaced = os.metadata.isProgressive;
  // o.op.structure.special.hasProfile = os.metadata.hasProfile;
  o.op.structure.hasPalette = os.metadata.paletteBitDepth !== undefined;
  o.op.headGot = true;

  if( o.op.onHead )
  o.op.onHead( o.op );

  return o.op;

  /* */

  function channelAdd( name )
  {
    // const depthMap =
    // {
    //   uchar : 8
    // }

    // o.op.structure.channelsMap[ name ] =
    // {
    //   name,
    //   bits : depthMap[ os.metadata.depth ],
    //   order : o.op.structure.channelsArray.length
    // };
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

//

function _readGeneralBufferAsync( o )
{
  let self = this;
  let ready = new _.Consequence();
  let data = {};

  try
  {
    if( o.mode === 'head' )
    {
      Backend( _.bufferNodeFrom( o.data ) )
      .metadata()
      .then( ( metadata ) =>
      {
        self._structureHandle({ originalStructure : { metadata }, op : o, mode : 'full' });
        ready.take( o );
      });
    }
    else
    {
      Backend( _.bufferNodeFrom( o.data ) )
      .metadata()
      .then( ( metadata ) =>
      {
        console.log( metadata )
        data.metadata = metadata;

        Backend( _.bufferNodeFrom( o.data ) )
        .raw()
        .toBuffer()
        .then( ( buffer ) =>
        {
          // console.log( buffer )
          data.buffer = buffer;
          self._structureHandle({ originalStructure : data, op : o, mode : 'full' });
          ready.take( o );
        } )
      } )
    }
  }
  catch( err )
  {
    throw _.err( err );
  }

  return ready;
}

//

function _readGeneralBufferSync( o )
{
  let self = this;
  let ready = self._readGeneralBufferAsync( o );
  ready.deasync()
  return ready;
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

// --
// relations
// --

let Formats = [ 'png', 'jpg', 'webp', 'gif', 'svg' ];
let Exts = [ 'png', 'jpg', 'jpeg', 'webp', 'gif', 'svg' ];

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
  SupportsStream : 1,
  SupportsAsync : 1,
  SupportsSync : 0,
  SupportsReadHead : 0
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

_.image.reader[ Self.shortName ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

} )();
