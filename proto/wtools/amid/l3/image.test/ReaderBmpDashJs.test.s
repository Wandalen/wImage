( function _ReaderBmpDashJs_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../../wtools/Tools.s' );
  require( '../image/entry/ReaderBmpDashJs.s' );
  require( './ReaderAbstractBmp.test.s' );
}

let _ = _global_.wTools;
let Parent = _global_.wTests.ImageReadAbstractBmp;

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

  name : 'ImageReadBmpDashJs',
  abstract : 0,
  enabled : 0,

  context :
  {
    ext : 'bmp',
    format : 'bmp',
    readerName : 'BmpDashJs',
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
