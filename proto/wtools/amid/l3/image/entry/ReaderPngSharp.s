( function _ReaderPngjs_s_()
{

'use strict';

/**
 * Plugin for wImageRader to read PNG images with backend npm:///png.js.
  @module Tools/mid/ImageReaderPngjs
*/

if( typeof module !== 'undefined' )
{
  const _ = require( '../include/ReaderPngSharp.s' )
  module[ 'exports' ] = _global_.wTools;
}

})();
