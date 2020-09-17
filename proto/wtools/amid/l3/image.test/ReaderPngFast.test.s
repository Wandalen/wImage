( function _ReaderPngFast_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../../wtools/Tools.s' );
  require( '../image/entry/ReaderPngFast.s' );
  require( './ReaderAbstractPng.test.s' );
}

let _ = _global_.wTools;
let Parent = _global_.wTests.ImageReadAbstractPng;

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

  name : 'ImageReadPngFast',
  abstract : 0,
  // enabled : 0,

  context :
  {
    ext : 'png',
    format : 'buffer.png',
    readerName : 'PngFast',
  },

  tests :
  {
  },

}

//

var Self = new wTestSuite( Proto ).inherit( Parent );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
