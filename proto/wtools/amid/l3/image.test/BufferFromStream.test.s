( function _Buffer_From_Stream_test_s_( )
{

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../../wtools/Tools.s' );
  require( '../image/entry/Reader.s' );
  _.include( 'wTesting' );
}

let _ = _global_.wTools;
let bufferFromStream = require( __dirname + '/../image/l5_reader/BufferFromStream.s' );

// --
// context
// --

function onSuiteBegin( test )
{
  let context = this;

  context.suiteTempPath = _.path.tempOpen( _.path.join( __dirname, '../..' ), 'ImageRead' );
  // context.assetsOriginalPath = _.path.join( __dirname, '_assets' );

}

//

function onSuiteEnd( test )
{
  let context = this;

  _.assert( _.strHas( context.suiteTempPath, '/ImageRead' ) )
  _.path.tempClose( context.suiteTempPath );

}

// --
// tests
// --

function bufferFromStream_( test )
{
  // let a = test.assetFor( 'basic' );
  // // let context = this;
  test.case = 'test';
  let stream = _.fileProvider.streamRead
  ({
    filePath : 'D:/programming/BFS/wImage/wImage/proto/wtools/amid/l3/image.test/_assets/basic/Pixels-2x2.png',
    encoding : 'buffer.raw',
  });
  // debugger;
  var got = bufferFromStream({ src : stream });
  test.is( 1 )
  // debugger;
  // // console.log( 'data: ', got )
  got.then( ( data ) =>
  {

    console.log( 'data:' )
    console.log( data )
    try
    {
      test.is( _.bufferNodeIs( data ) );
    }
    catch( err )
    {
      console.log( 'ERROR: ', err );
    }
  } );
  // got.then( ( data ) =>
  // {
  //   console.log( 'data:' )
  //   console.log( data )
  //   test.is( _.bufferNodeIs( data ) );
  // } );
  // console.log( bufferFromStream({ src : stream }) );
  // bufferFromStream({ src : stream })
  // debugger
  // })
  test.case = 'test'
  test.il( 1, 1 );

}

// --
// declare
// --

var Proto =
{

  name : 'bufferFromStream',
  silencing : 1,

  onSuiteBegin,
  onSuiteEnd,

  context :
  {
    suiteTempPath : null,
    assetsOriginalPath : null,
    appJsPath : null,
    ext : 'png',
    format : 'png',
    readerName : 'PngDotJs',
  },

  tests :
  {
    bufferFromStream_
  },

}

//

var Self = new wTestSuite( Proto )
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );
})()
