( function _Basic_s_( )
{

'use strict';

/* image */

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../../../wtools/Tools.s' );

  _.include( 'wCopyable' );
  _.include( 'wFiles' );
  _.include( 'wConsequence' );
  _.include( 'wGdf' );

  module[ 'exports' ] = _global_.wTools;
}

})();
