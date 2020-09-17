( function _ReaderStructure_s_( )
{

'use strict';

let _ = _global_.wTools;
let Self = _.image.rstructure = _.image.rstructure || Object.create( null );

// --
// inter
// --

function from( o )
{

  o = o || Object.create( null );
  o = _.routineOptions( from, o );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( !o.special )
  o.special = Object.create( null );
  if( !o.channelsMap )
  o.channelsMap = Object.create( null );
  if( !o.channelsArray )
  o.channelsArray = [];

  return o;
}

from.defaults =
{
  special : null,
  channelsMap : null,
  channelsArray : null,
}

//

function validate( o )
{
  o = _.routineOptions( validate, arguments );

  _.assert( _.longIs( o.dims ), 'Expects {- o.dims -}' );
  _.assert( o.buffer === null || _.bufferAnyIs( o.buffer ), 'Expects {- o.buffer -}' );
  // _.assert( _.mapIs( o.channelsMap ), 'Expects {- o.channelsMap -}' );
  _.assert( _.longIs( o.channelsArray ), 'Expects {- o.channelsArray -}' );
  // _.assert
  // (
  //   o.bytesPerPixel === Math.ceil( o.bitsPerPixel / 8 ),
  //   `Mismatch of {- o.bytesPerPixel=${o.bytesPerPixel} -} and {- o.bitsPerPixel=${o.bitsPerPixel} -}`
  // );

  return o;
}

validate.defaults =
{
  ... from.defaults,
  buffer : null,
  dims : null,
  bytesPerPixel : null,
  bitsPerPixel : null,
  hasPalette : null,
}

// --
// declare
// --

let Extension =
{

  from,
  validate,

}
debugger
_.mapExtend( Self, Extension );
debugger
//

if( typeof module !== 'undefined' )
module[ 'exports' ] = _global_.wTools;

})();
