( function _ReaderOmggif_test_s_( )
{

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../../wtools/Tools.s' );
  require( '../image/entry/ReaderOmggif.s' );
  require( './ReaderAbstractGif.test.s' );
}

let _ = _global_.wTools;
let Parent = _global_.wTests.ImageReadAbstractGif;

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

  name : 'ImageReadOmggif',
  abstract : 0,
  enabled : 0,

  context :
  {
    ext : 'gif',
    format : 'gif',
    readerName : 'Omggif',
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
