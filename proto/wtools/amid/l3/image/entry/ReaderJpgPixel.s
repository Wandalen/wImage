( function _ReaderJpgpixel_s_()
{

'use strict';

/**
 * Plugin for wImageRader to read PNG images with backend npm:///pixel-jpg.
  @module Tools/mid/ImageReaderJpgpixel
*/

if( typeof module !== 'undefined' )
{
  let _ = require( '../include/ReaderJpgPixel.s' )
  module[ 'exports' ] = _global_.wTools;
}

})();
