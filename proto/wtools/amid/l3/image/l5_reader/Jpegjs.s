( function _PngJpegjs_s_()
{

'use strict';

/**
 * @classdesc Abstract interface to read image.
 * @class wImageReaderPngLwipjs
 * @namespace wTools
 * @module Tools/mid/ImageReader
 */

const _ = _global_.wTools;
let Backend = require( 'jpeg-js' );
const Parent = _.image.reader.Abstract;
let bufferFromStream = require( './BufferFromStream.s' );
const Self = wImageReaderJpegjs;
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

  _.routine.assertOptions( _structureHandle, arguments );
  _.assert( _.object.isBasic( os ) );
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

  o.op.params.headGot = true;

  if( o.op.params.onHead )
  o.op.params.onHead( o.op );

  return o.op;

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

  _.routine.assertOptions( _readGeneral, o );
  _.assert( arguments.length === 1 );
  _.assert( _.longHas( [ 'full', 'head' ], o.params.mode ) );
  _.assert( o.in.format === null || _.strIs( o.in.format ) );
  _.assert( o.out.format === null || _.strIs( o.out.format ) );
  _.assert( o.in.data !== undefined );

  o.params.headGot = false;

  if( _.streamIs( o.in.data ) )
  {

    if( o.in.format === null )
    o.in.format = 'stream.jpg';

    if( o.sync )
    return self._readGeneralStreamSync( o )
    else
    return self._readGeneralStreamAsync( o );
  }
  else
  {
    if( o.in.format === null )
    o.in.format = 'buffer.jpg';

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
    let os = Backend.decode( _.bufferNodeFrom( o.in.data ) );
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
    let os = Backend.decode( _.bufferNodeFrom( o.in.data ) );
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
  _.routine.assertOptions( _readHead, o );
  if( !o.params.mode )
  o.params.mode = 'head';
  return self._readGeneral( o );
}

_readHead.defaults =
{
  ... Parent.prototype._readHead.defaults,
}

//

function _read( o )
{
  let self = this;
  _.assert( arguments.length === 1 );
  _.routine.assertOptions( _read, o );
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

let Formats = [ 'jpg' ];
let Exts = [ 'jpg', 'jpeg' ];

let Composes =
{
  shortName : 'jpegjs',
  ext : _.define.own([ 'jpg', 'jpeg' ]),
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

_.assert( !_.image.reader[ Self.shortName ] );
// new Self();
_.image.reader[ Self.shortName ] = new Self();
_.assert( !!_.image.reader[ Self.shortName ] );

// _.image.reader[ Self.shortName ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
