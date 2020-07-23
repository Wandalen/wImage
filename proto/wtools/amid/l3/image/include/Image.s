( function _Image_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( './Basic.s' );

  require( './Reader.s' );
  require( './ReaderPngjs.s' );
  // require( './ReaderPngDotJs.s' );
  // require( './ReaderPngSharp.s' );
  // require( './ReaderPngNodeLib.s' );
  // require( './ReaderPngDashJs.s' );
  // require( './Writer.s' );

  module[ 'exports' ] = _global_.wTools;
}

})();
