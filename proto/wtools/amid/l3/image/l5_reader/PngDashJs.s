( function _PngPngDashJs_s_()
{

'use strict';

/**
 * @classdesc Abstract interface to read image.
 * @class wImageReaderPngLwipjs
 * @namespace wTools
 * @module Tools/mid/ImageReader
 */

let _ = _global_.wTools;
let Backend = require( 'png-js' );
let Parent = _.image.reader.Abstract;
let Self = wImageReaderPngDashJs;
function wImageReaderPngDashJs()
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Png-js';

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

  o.op.structure.dims = [ os.width, os.height ];

  os = os._parser ? os._parser._metaData : os;

  o.op.originalStructure = os;

  _.assert( !os.palette, 'not implemented' );

  if( os.color )
  {
    _.assert( o.op.structure.channelsArray.length === 0 );
    channelAdd( 'red' );
    channelAdd( 'green' );
    channelAdd( 'blue' );
  }

  if( os.colorType === 4 )
  {
    _.assert( o.op.structure.channelsArray.length === 0 );
    channelAdd( 'gray' );
  }

  if( os.alpha )
  {
    channelAdd( 'alpha' );
  }

  o.op.structure.bytesPerPixel = os.bpp;
  o.op.structure.bitsPerPixel = _.mapVals( o.op.structure.channelsMap ).reduce( ( val, channel ) => val + channel.bits, 0 );

  o.op.structure.special.interlaced = os.interlace;
  o.op.structure.hasPalette = os.palette;

  o.op.headGot = true;

  if( o.op.onHead )
  o.op.onHead( o.op );

  return o.op;

  /* */

  function channelAdd( name )
  {
    o.op.structure.channelsMap[ name ] = { name, bits : os.depth, order : o.op.structure.channelsArray.length };
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

  // if( _.streamIs( o.data ) )
  // {
  //   if( o.sync )
  //   return self._readGeneralStreamSync( o );
  //   else
  //   return self._readGeneralStreamAsync( o );
  // }
  // else
  // {
  // if( o.sync )
  // return self._readGeneralBufferSync( o );
  // else
  return self._readGeneralBufferAsync( o );
  // }

}

_readGeneral.defaults =
{
  ... Parent.prototype._read.defaults,
  mode : 'full',
}

//

// function _readGeneralStreamSync( o )
// {
//   let self = this;
//   let ready = self._readGeneralStreamAsync( o );
//   ready.deasync();
//   return ready.sync();
// }

// //

// function _readGeneralStreamAsync( o )
// {
//   let self = this;
//   let ready = new _.Consequence();
//   let backend = new Backend.PNG();
//   let done;

//   backend
//   .on( 'error', ( err ) => errorHandle( err ) )
//   .on( 'metadata', function ( os )
//   {
//     if( o.mode === 'head' )
//     {
//       o.data.close();
//       backend._parser._paused = true;
//       backend._parser._buffered = 0;
//     }
//     self._structureHandle({ originalStructure : os, op : o, mode : 'head' });
//     if( o.mode === 'head' )
//     {
//       done = true;
//       ready.take( o );
//     }
//   })
//   .on( 'parsed', function ( data )
//   {
//     if( o.mode === 'head' )
//     return;
//     if( done )
//     return;
//     _.assert( !!o.headGot );
//     o.originalStructure.data = data;
//     self._structureHandle({ originalStructure : o.originalStructure, op : o, mode : 'full' });
//     ready.take( o );
//     done = true;
//   })

//   o.data.pipe( backend );

//   return ready;

//   function errorHandle( err )
//   {
//     if( o.headGot )
//     return;
//     if( done )
//     return;
//     err = _.err( err )
//     done = err;
//     ready.error( err );
//   }
// }

// //

// function _readGeneralBufferSync( o )
// {
//   let self = this;
//   /* qqq : write proper code for mode : head */
//   try
//   {
//     let os = Backend.PNG.sync.read( _.bufferNodeFrom( o.data ) );
//     self._structureHandle({ originalStructure : os, op : o, mode : 'full' });
//   }
//   catch( err )
//   {
//     throw _.err( err );
//   }
//   return o;
// }

// //

function _readGeneralBufferAsync( o )
{
  let self = this;
  let ready = new _.Consequence();
  // let backend = new Backend( _.bufferNodeFrom( o.data ) );
  let done;


  Backend.decode( _.bufferNodeFrom( o.data ).readUInt8(), ( err, os ) =>
  {
    if( err )
    console.log( 'ERROR: ', err );
    // return errorHandle( err );
    self._structureHandle({ originalStructure : os, op : o, mode : 'full' });
    console.log( os )
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
  // _readGeneralStreamSync,
  // _readGeneralStreamAsync,
  // _readGeneralBufferSync,
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
