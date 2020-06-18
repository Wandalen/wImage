( function _PngDotJs_s_()
{

'use strict';

/**
 * @classdesc Abstract interface to read image.
 * @class wImageReaderPngdotjs
 * @namespace wTools
 * @module Tools/mid/ImageReader
 */

let _ = _global_.wTools;
let Backend = require( 'png.js' );
let Parent = _.image.reader.Abstract;
let Self = wImageReaderPngDotJs;
function wImageReaderPngDotJs()
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'PngDotJs';

// --
// implementation
// --

function _read( o )
{
  let self = this;
  _.assert( arguments.length === 1 );
  _.assertRoutineOptions( _read, o );
  o.mode = 'full';

  try
  {
    let reader = new Backend( _.bufferNodeFrom( o.data ) );
    reader.parse( ( err, png ) =>
    {
      if( err ) console.log( err );
      console.log( png );
      self._structureHandle({ originalStructure : png, op : o, mode : 'full' });
    } );
  }
  catch( err )
  {
    throw _.err( err );
  }

  return o;
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

} )();
