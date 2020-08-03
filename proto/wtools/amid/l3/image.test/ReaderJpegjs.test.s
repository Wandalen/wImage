( function _ReaderJpegJs_test_s_( )
{

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../../wtools/Tools.s' );
  require( '../image/entry/ReaderJpegjs.s' );
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

  name : 'ImageReadJpegjs',
  abstract : 0,

  context :
  {
    ext : 'jpg',
    format : 'jpg',
    readerName : 'Jpegjs',
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
