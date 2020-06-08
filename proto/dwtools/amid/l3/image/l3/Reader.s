( function _Reader_s_() {

'use strict';

/**
 * @classdesc Abstract interface to read image.
 * @class wImageReader
 * @namespace wTools
 * @module Tools/mid/ImageReader
 */

let _ = _global_.wTools;
let Parent = null;
let Self = function wImageReaderAbstract()
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Abstract';

//

function init( o )
{
  let self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  _.workpiece.initFields( self );
  Object.preventExtensions( self )

  if( o )
  self.copy( o );

  self.form();
  return self;
}

//

function form()
{
  let self = this;

  _.assert( !self.formed );
  _.assert( arguments.length === 0, 'Expects no arguments' );

  // self.formAssociates();

  self.formed = 1;
  return self;
}

//

let _read = Object.create( null );

_read.defaults =
{
  data : null,
  filePath : null,
  format : null,
  ext : null,
  sync : 1,
}

//

function read( o )
{
  let self = this;
  let ready = new _.Consequence().take( null );
  let result;

  o = _.routineOptions( read, o );

  if( !o.structure )
  o.structure = Object.create( null );

  if( !o.structure.special )
  o.structure.special = Object.create( null );
  if( !o.structure.channelsMap )
  o.structure.channelsMap = Object.create( null );
  if( !o.structure.channelsArray )
  o.structure.channelsArray = [];

  ready.then( () => self._read( o ) );
  ready.then( () => end() );
  ready.catch( ( err ) =>
  {
    o.err = _.err( err, '\n', `Failed to read image ${o.filePath}` );
    throw o.err;
  });

  if( o.sync )
  return ready.sync();
  return ready;

  function end()
  {
    _.assert( _.longIs( o.structure.dims ), 'Expects {- o.dims -}' );
    _.assert( !!o.structure.buffer, 'Expects {- o.buffer -}' );
    _.assert( _.mapIs( o.structure.channelsMap ), 'Expects {- o.channelsMap -}' );
    _.assert( _.longIs( o.structure.channelsArray ), 'Expects {- o.channelsArray -}' );
    _.assert
    (
      o.structure.bytesPerPixel === Math.ceil( o.structure.bitsPerPixel / 8 ),
      `Mismatch of {- o.bytesPerPixel=${o.structure.bytesPerPixel} -} and {- o.bitsPerPixel=${o.structure.bitsPerPixel} -}`
    );
    return o;
  }

}

read.defaults =
{
  ... _read.defaults,
}

//

function Supports( o )
{
  let cls = this.Self;

  o = _.routineOptions( Supports, arguments );

  if( o.format )
  if( _.longHas( cls.Formats, o.format ) )
  return { readerClass : cls, format : cls.Formats[ 0 ] };

  if( o.ext )
  if( _.longHas( cls.Exts, o.ext ) )
  return { readerClass : cls, format : cls.Formats[ 0 ] };

  return false;
}

Supports.defaults =
{
  format : null,
  ext : null,
  filePath : null,
  data : null,
}

//

function _Supports( o )
{
  let proto = this;
  return false;
}

_Supports.defaults =
{
  ... Supports.defaults,
}

// --
//
// --

let Formats = null;
let Exts = null;

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
  formed : 0,
}

let Statics =
{
  Supports,
  _Supports,
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

  init,
  form,

  _read,
  read,

  Supports,
  _Supports,

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

_.Copyable.mixin( Self );

//

_.image.reader[ Self.shortName ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
