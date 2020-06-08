( function _Basic_s_( )
{

'use strict';

/* image */

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../../../dwtools/Tools.s' );

  _.include( 'wCopyable' );
  _.include( 'wFiles' );
  _.include( 'wConsequence' );

  module[ 'exports' ] = _global_.wTools;
}

})();
