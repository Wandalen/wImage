( function _ReaderStructure_s_( )
{

'use strict';

const _ = _global_.wTools;
const Self = _.image.rstructure = _.image.rstructure || Object.create( null );

// --
// inter
// --

function from( o )
{

  o = o || Object.create( null );
  o = _.routine.options_( from, o );
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
  o = _.routine.options_( validate, arguments );

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

_.props.extend( Self, Extension );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = _global_.wTools;

})();
