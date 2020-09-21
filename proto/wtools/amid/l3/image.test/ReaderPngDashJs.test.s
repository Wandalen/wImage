( function _ReaderPngDash_test_s_( )
{

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../../wtools/Tools.s' );
  require( '../image/entry/ReaderPngDashJs.s' );
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

  name : 'ImageReadPngDashJs',
  abstract : 0,
  enabled : 0,

  context :
  {
    ext : 'png',
    inFormat : 'buffer.png',
    readerName : 'PngDashJs',
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
