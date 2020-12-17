( function _ReaderPngFast_s_()
{

'use strict';

/**
 * Plugin for wImageRader to read PNG images with backend npm:///fast-png.
  @module Tools/mid/ImageReaderPngFast
*/

if( typeof module !== 'undefined' )
{
  let _ = require( '../include/ReaderPngFast.s' )
  module[ 'exports' ] = _global_.wTools;
}

})();
