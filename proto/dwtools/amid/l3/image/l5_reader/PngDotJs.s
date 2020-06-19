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

  _.assert( !!o.sync, 'not implemented' );
  _.assert( _.bufferAnyIs( o.data ), 'not implemented' );

  o.mode = 'full';

  try
  {
    debugger;
    let reader = new Backend( _.bufferNodeFrom( o.data ) );
    debugger;
    reader.parse( ( err, png ) =>
    {
      debugger;
      if( err ) console.log( err );
      console.log( png );
      // self._structureHandle({ originalStructure : png, op : o, mode : 'full' });
      debugger;
    });
  }
  catch( err )
  {
    debugger;
    throw _.err( err );
  }

  debugger;
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
