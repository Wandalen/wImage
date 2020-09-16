( function _ReaderPngDotJs_test_s_( )
{

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../../wtools/Tools.s' );
  require( '../image/entry/ReaderPngDotJs.s' );
  require( './ReaderAbstractPng.test.s' );
}

let _ = _global_.wTools;
let Parent = _global_.wTests.ImageReadAbstractPng; /* xxx : rename */

// --
// context
// --

// --
// tests
// --

// --
// declare
// --

var Proto =
{

  name : 'ImageReadPngDotJs',
  abstract : 0,
  enabled : 0,

  //   context :
  //   {
  //     ext : 'png',
  //     inFormat : 'png',
  //     readerName : 'PngDotJs',
  //   },

  tests :
  {


  },

}

//

var Self = new wTestSuite( Proto ).inherit( Parent );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
