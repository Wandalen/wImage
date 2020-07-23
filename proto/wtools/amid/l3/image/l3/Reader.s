( function _Reader_s_()
{

'use strict';

/**
 * @classdesc Abstract interface to read image.
 * @class wImageReader
 * @namespace wTools
 * @module Tools/mid/ImageReader
 */

let _ = _global_.wTools;
let Parent = null;
let Self = wImageReaderAbstract;
function wImageReaderAbstract()
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Abstract';

//

function init( o )
{
  let self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  // find out
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

let _readHead = Object.create( null );

_readHead.defaults =
{
  ... _.mapBut( _.image.read.defaults, [ 'mode' ] ),
  structure : null,
}

//

function readHead( o )
{
  let self = this;
  let ready = new _.Consequence().take( null );
  let result;

  o = _.routineOptions( readHead, o );
  o.structure = _.image.rstructure.from( o.structure );
  debugger;
  ready.then( () => self._readHead( o ) );
  debugger;
  ready.then( () => _.image.rstructure.validate( o.structure ) && o );
  ready.catch( ( err ) =>
  {
    o.err = _.err( err, '\n', `Failed to read image ${o.filePath}` );
    throw o.err;
  });

  if( o.sync )
  return ready.sync();
  return ready;
}

readHead.defaults =
{
  ... _readHead.defaults,
}

//

let _read = Object.create( null );

_read.defaults =
{
  ... _readHead.defaults,
}

//

function read( o )
{
  let self = this;
  let ready = new _.Consequence().take( null );
  let result;

  o = _.routineOptions( read, o );
  o.structure = _.image.rstructure.from( o.structure );

  ready.then( () => self._read( o ) );
  ready.then( () => _.image.rstructure.validate( o.structure ) && o );
  ready.catch( ( err ) =>
  {
    o.err = _.err( err, '\n', `Failed to read image ${o.filePath}` );
    throw o.err;
  });

  if( o.sync )
  return ready.sync();
  return ready;
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

  if( !o.ext )
  if( o.filePath )
  o.filePath = _.path.ext( o.filePath );
  if( o.ext )
  o.ext = o.ext.toLowerCase()

  if( o.format )
  if( _.longHas( cls.Formats, o.format ) )
  console.log();

  if( o.format )
  if( _.longHas( cls.Formats, o.format ) )
  return { readerClass : cls, format : cls.Formats[ 0 ] };

  if( o.ext )
  if( _.longHas( cls.Exts, o.ext ) )
  return { readerClass : cls, format : cls.Formats[ 0 ] };

  return cls._Supports( o );
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
// relations
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

  _readHead,
  readHead,

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
