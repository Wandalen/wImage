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

function _readGeneral( o )
{
  let self = this;
  let metadata;

  _.assert( arguments.length === 1 );
  _.assertRoutineOptions( _readGeneral, o );
  _.assert( _.longHas( [ 'full', 'head' ], o.mode ) );

  if( _.streamIs( o.data ) )
  {
    if( o.sync )
    return readStreamSync();
    else
    return readStreamAsync();
  }
  else
  {
    if( o.sync )
    return readBufferSync();
    else
    return readBufferAsync();
  }

  /* */

  function readStreamAsync()
  {
    let ready = new _.Consequence();
    let backend = new Backend.PNG();

    _.assert( o.mode === 'head' );

    o.data.pipe( backend )
    .on( 'metadata', function ( _metadata )
    {
      o.data.close();
      backend._parser._paused = true;
      backend._parser._buffered = 0;
      handle( _metadata )
      if( o.onHead )
      o.onHead( o );
      ready.take( o );
    });

    return ready;
  }

  /* */

  function readBufferSync()
  {
    try
    {
      let os = Backend.PNG.sync.read( _.bufferNodeFrom( o.data ) );
      metadata = os;
      handle( os );
    }
    catch( err )
    {
      throw _.err( err );
    }
    return o;
  }

  /* */

  function readBufferAsync()
  {
    let ready = new _.Consequence();

    let stream = new Backend.PNG({}).parse( _.bufferNodeFrom( o.data ), ( err, os ) =>
    {
      if( err )
      return ready.error( _.err( err ) );
      ready.take( handle( os ) );
    });

    return ready;
  }

  /* */

  function handle( os )
  {
    if( o.mode === 'full' )
    o.structure.buffer = _.bufferRawFrom( os.data );
    else
    o.structure.buffer = null;
    o.structure.dims = [ os.width, os.height ];

    metadata = os._parser ? os._parser._metaData : os;

    o.originalStructure = metadata;

    _.assert( !metadata.palette, 'not implemented' );

    if( metadata.color )
    {
      _.assert( o.structure.channelsArray.length === 0 );
      channelAdd( 'red' );
      channelAdd( 'green' );
      channelAdd( 'blue' );
    }

    if( metadata.colorType === 4 )
    {
      _.assert( o.structure.channelsArray.length === 0 );
      channelAdd( 'gray' );
    }

    if( metadata.alpha )
    {
      channelAdd( 'alpha' );
    }

    o.structure.bytesPerPixel = metadata.bpp;
    o.structure.bitsPerPixel = _.mapVals( o.structure.channelsMap ).reduce( ( val, channel ) => val + channel.bits, 0 );

    o.structure.special.interlaced = metadata.interlace;
    o.structure.hasPalette = metadata.palette;

    return o;
  }

  /* */

  function channelAdd( name )
  {
    o.structure.channelsMap[ name ] = { name, bits : metadata.depth, order : o.structure.channelsArray.length };
    o.structure.channelsArray.push( name );
  }

  /* */

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
