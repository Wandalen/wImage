( function _PngSharp_s_()
{ 
// buffer sync, buffer async
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
  console.log( os );
  if( os === null )
  os = o.op.originalStructure;

  // logger.log( '_structureHandle', o.mode );
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

  o.op.structure.bitsPerPixel = _.mapVals( o.op.structure.channelsMap ).reduce( ( val, channel ) => val + channel.bits, 0 );
  o.op.structure.bytesPerPixel = Math.round( o.op.structure.bitsPerPixel / 8 );
  o.op.structure.special.interlaced = os.metadata.isProgressive;
  o.op.structure.hasPalette = os.palette !== undefined;
  o.op.headGot = true;

  if( o.op.onHead )
  o.op.onHead( o.op );

  return o.op;

  /* */

  function channelAdd( name )
  {
    o.op.structure.channelsMap[ name ] = { name, bits : 8, order : o.op.structure.channelsArray.length };
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
  {
    if( o.sync )
    return self._readGeneralStreamSync( o );
    else
    return self._readGeneralStreamAsync( o );
  }
  else
  {
  if( o.sync )
  return self._readGeneralBufferSync( o );
  else
  return self._readGeneralBufferAsync( o );
  }

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
  // return self._readGeneral( o );
  if( o.sync )
  return self._readGeneralBufferHeadSync( o );
  else
  return self._readGeneralBufferHeadAsync( o );
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

function _readGeneralBufferHeadAsync( o )
{
  let self = this;
  let ready = new _.Consequence();
  let data = {};
  /* qqq : write proper code for mode : head */
  try
  {
    Backend( _.bufferNodeFrom( o.data ) )
    .metadata()
    .then( ( metadata ) =>
    {
      data.metadata = metadata;
      // console.log( metadata )
      self._structureHandle({ originalStructure : data, op : o, mode : 'full' });
      ready.take( o );
    } )

  }
  catch( err )
  {
    throw _.err( err );
  }

  return ready;
}



function _readGeneralBufferHeadSync( o )
{
  let self = this;
  // let backend = new Backend.PNG({})

  /* qqq : write proper code for mode : head */
  let ready = self._readGeneralBufferHeadAsync( o );

  ready.deasync()

  return ready;
}

//

function _readGeneralBufferAsync( o )
{
  let self = this;
  let ready = new _.Consequence();
  let data = {};
  /* qqq : write proper code for mode : head */
  try
  {
    Backend( _.bufferNodeFrom( o.data ) )
    .metadata()
    .then( ( metadata ) =>
    {
      // console.log( metadata )
      data.metadata = metadata;

      Backend( _.bufferNodeFrom( o.data ) )
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
  catch( err )
  {
    throw _.err( err );
  }

  return ready;
}



function _readGeneralBufferSync( o )
{
  let self = this;

  /* qqq : write proper code for mode : head */
  let ready = self._readGeneralBufferAsync( o );

  ready.deasync()

  return ready;
}



function _readGeneralStreamAsync()
{
  Backend( _.bufferNodeFrom( o.data ) )
  .on('info', function(info) {
    // console.log('Image height is ' + info.height);
    console.log( info );
  });
}



function _readGeneralStreamSync()
{
  let self = this;
  let ready = self._readGeneralStreamAsync( o );
  ready.deasync();
  return ready.sync();
}

// --
// relations
// --

let Formats = [ 'png' ];
let Exts = [ 'png' ];

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
  _readGeneralBufferSync,
  _readGeneralBufferHeadSync,
  _readGeneralBufferAsync,
  _readGeneralBufferHeadAsync,
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
