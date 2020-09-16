( function _ReaderUtifJs_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../../wtools/Tools.s' );
  require( '../image/entry/ReaderUtifJs.s' );
  require( './ReaderAbstractTif.test.s' );
}

let _ = _global_.wTools;
let Parent = _global_.wTests.ImageReadAbstractTif;

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

  name : 'ImageReadUtifJs',
  abstract : 0,
  enabled : 0,

  context :
  {
    ext : 'tif',
    format : 'tif',
    readerName : 'UtifJs',
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
