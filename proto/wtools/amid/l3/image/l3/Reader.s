( function _Reader_s_()
{

'use strict';

/**
 * @classdesc Abstract interface to read image.
 * @class wImageReader
 * @namespace wTools
 * @module Tools/mid/ImageReader
 */

const _ = _global_.wTools;
const Parent = _.gdf.Encoder;
const Self = wImageReaderAbstract;
function wImageReaderAbstract()
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Abstract';

//

function form()
{
  let self = this;

  _.assert( !self.formed );
  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( _.image.reader[ self.Self.name ] === undefined );

  _.image.reader[ self.Self.shortName ] = self;

  return Parent.prototype.form.apply( this, arguments );
}

//

let _readHead = Object.create( null );

_readHead.defaults =
{
  ... Parent.prototype._encode.defaults,
}

//

function readHead( o )
{
  let self = this;
  let ready = new _.Consequence().take( null );
  let result;

  o = _.routine.options_( read, o );
  o.params = o.params || Object.create( null );
  if( !o.params.mode )
  o.params.mode = 'head';

  ready.then( () => self.encode( o ) );

  if( o.sync )
  return ready.sync();
  return ready;
}

readHead.defaults =
{
  ... Parent.prototype.encode.defaults,
}

//

let _read = Object.create( null );

_read.defaults =
{
  ... Parent.prototype._encode.defaults,
}

//

function read( o )
{

  let self = this;
  let ready = new _.Consequence().take( null );
  let result;

  o = _.routine.options_( read, o );
  o.params = o.params || Object.create( null );
  if( !o.params.mode )
  o.params.mode = 'full';

  ready.then( () => self.encode( o ) );

  if( o.sync )
  return ready.sync();
  return ready;
}

read.defaults =
{
  ... Parent.prototype.encode.defaults,
}

//

function _encode( o )
{
  let self = this;
  let ready = new _.Consequence().take( null );
  let result;

  o = _.routine.assertOptions( _encode, o );
  o.out.data = _.image.rstructure.from( o.out.data );

  ready.then( () => self._read( o ) );
  ready.then( ( op ) =>
  {
    return _.image.rstructure.validate( o.out.data ) && o;
  });
  ready.catch( ( err ) =>
  {
    o.err = _.err( err, '\n', `Failed to read image ${o.filePath}` );
    throw o.err;
  });

  if( o.sync )
  return ready.sync();
  return ready;
}

_encode.defaults =
{
  ... Parent.prototype._encode.defaults,
}

//

function Supports( o )
{
  let cls = this.Self;

  o = _.routine.options_( Supports, arguments );

  if( !o.ext )
  if( o.filePath )
  o.filePath = _.path.ext( o.filePath );
  if( o.ext )
  o.ext = o.ext.toLowerCase()

  if( o.inFormat )
  if( _.longHas( cls.Formats, o.inFormat ) )
  console.log();

  if( o.inFormat )
  if( _.longHas( cls.Formats, o.inFormat ) )
  return { readerClass : cls, inFormat : cls.Formats[ 0 ] };

  if( o.ext )
  if( _.longHas( cls.Exts, o.ext ) )
  return { readerClass : cls, inFormat : cls.Formats[ 0 ] };

  return cls._Supports( o );
}

Supports.defaults =
{
  inFormat : null,
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

//

function onEncode( op )
{
  let self = this;
  _.assert( _.strIs( op.in.data ) );
  let ready = new _.Consequence().take( null );

  _.assert( 0, 'not tested' );

  let o2 =
  {
    data : op.in.data,
  }

  ready.then( () => self.read( o2 ) );

  ready.then( ( op2 ) =>
  {

    op.out.data = op2.out.data;
    return op;
  });

  return ready;
}

// --
// relations
// --

let Formats = null;
let Exts = null;

let Composes =
{
  onEncode,
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

  //

  form,

  _readHead,
  readHead,

  _read,
  read,

  _encode,

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
//

_.image.reader[ Self.shortName ] = Self;

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
