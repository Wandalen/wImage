( function _Writer_s_( ) {

'use strict';

let _ = _global_.wTools;
let Self = _.image = _.image || Object.create( null );
_.image.writer = _.image.writer || Object.create( null );

// --
// inter
// --

function write( o )
{



}

write.defaults =
{
  filePath : null,
  format : null,
}

// --
// declare
// --

let Extension =
{

  write,

}

_.mapExtend( Self, Extension );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = _global_.wTools;

})();
