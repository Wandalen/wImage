( function _Basic_s_( )
{

'use strict';

/* image */

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../../../node_modules/Tools' );

  _.include( 'wCopyable' );
  _.include( 'wFiles' );
  _.include( 'wConsequence' );
  _.include( 'wGdf' );

  module[ 'exports' ] = _global_.wTools;
}

})();
