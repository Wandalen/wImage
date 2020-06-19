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
let Self = wImageReaderPngSharp;
function wImageReaderPngSharp()
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'PngSharp';

// --
// implementation
// --

function _read( o )
{
  let self = this;
  _.assert( arguments.length === 1 );
  _.assertRoutineOptions( _read, o );
  o.mode = 'full';

  /* qqq : write proper code for mode : head */
  try
  {
    debugger;
    Backend( _.bufferNodeFrom( o.data ) ).raw()
    .toBuffer({ resolveWithObject : true })
    .then( ({ data }) => 
    {
      debugger;
      console.log(data)
      // self._structureHandle({ originalStructure : data, op : o, mode : 'full' }) );
    });
    debugger;
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
