( function _ReaderPngLwip_s_()
{

'use strict';

/**
 * Plugin for wImageRader to read PNG images with backend npm:///pngjs.
  @module Tools/mid/ImageReaderPngjs
*/

if( typeof module !== 'undefined' )
{
  let _ = require( '../include/ReaderPngLwip.s' )
  module[ 'exports' ] = _global_.wTools;
}

})();
