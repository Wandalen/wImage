( function _Reader_s_( )
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( './Basic.s' );

  require( '../l1_namespace/Reader.s' );
  require( '../l1_namespace/ReaderStructure.s' );
  require( '../l3/Reader.s' );
  require( '../l7_namespace/Reader.s' );

  module[ 'exports' ] = _global_.wTools;
}

})();
