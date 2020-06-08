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
//
// --

function _read( o )
{
  let self = this;
  let metadata;

  _.assert( arguments.length === 1 );
  _.assertMapHasAll( o, _read.defaults );

  if( o.sync )
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
  else
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

  return o;

  /* */

  function handle( os )
  {
    o.originalStructure = os;
    o.structure.buffer = _.bufferRawFrom( os.data );
    o.structure.dims = [ os.width, os.height ];

    metadata = os._parser ? os._parser._metaData : os;

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

    // o.structure.special.hasIhdr = os._hasIHDR
    // o.structure.special.hasIend = os._hasIEND

    return o;
  }

  function channelAdd( name )
  {
    o.structure.channelsMap[ name ] = { name, bits : metadata.depth, order : o.structure.channelsArray.length };
    o.structure.channelsArray.push( name );
  }

}

_read.defaults =
{
  ... Parent.prototype._read.defaults,
}

// --
//
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
