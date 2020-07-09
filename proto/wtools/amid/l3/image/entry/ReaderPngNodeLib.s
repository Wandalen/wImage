( function _ReaderPngjs_s_()
{

'use strict';

/**
 * Plugin for wImageRader to read PNG images with backend npm:///node-libpng.
  @module Tools/mid/ImageReaderPngNodeLib
*/

if( typeof module !== 'undefined' )
{
  let _ = require( '../include/ReaderPngNodeLib.s' )
  module[ 'exports' ] = _global_.wTools;
}

})();
