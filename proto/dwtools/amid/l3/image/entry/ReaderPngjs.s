( function _ReaderPngjs_s_( )
{

'use strict';

/**
 * Plugin for wImageRader to read PNG images with backend npm:///pngjs.
  @module Tools/mid/ImageReaderPngjs
*/

if( typeof module !== 'undefined' )
{
  let _ = require( '../include/ReaderPngjs.s' )
  module[ 'exports' ] = _global_.wTools;
}

})();
