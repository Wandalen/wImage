( function _ReaderJpgPixel_test_s_( )
{

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../../wtools/Tools.s' );
  require( '../image/entry/ReaderJpgPixel.s' );
  require( './ReaderAbstractJpg.test.s' );
}

let _ = _global_.wTools;
let Parent = _global_.wTests.ImageReadAbstractJpg;

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

  name : 'ImageReadJpgPixel',
  abstract : 0,
  // enabled : 0,

  context :
  {
    ext : 'jpg',
    format : 'buffer.jpg',
    readerName : 'JpgPixel',
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
