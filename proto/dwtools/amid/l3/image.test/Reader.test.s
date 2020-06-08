( function _Reader_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../../dwtools/Tools.s' );
  _.include( 'wTesting' );
  require( '../image/entry/Reader.s' );
}

var _ = _global_.wTools;

// --
// context
// --

function onSuiteBegin( test )
{
  let context = this;

  context.suiteTempPath = _.path.pathDirTempOpen( _.path.join( __dirname, '../..'  ), 'ImageRead' );
  context.assetsOriginalPath = _.path.join( __dirname, '_assets' );

}

//

function onSuiteEnd( test )
{
  let context = this;

  _.assert( _.strHas( context.suiteTempPath, '/ImageRead' ) )
  _.path.pathDirTempClose( context.suiteTempPath );

}

// --
// tests
// --

function fileReadSync( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  /* */

  test.case = 'single path';

  a.reflect();

  var op = _.image.fileRead( a.abs( 'Pixels-2x2.png' ) );

  test.is( _.bufferRawIs( op.data ) );

  delete op.data;
  delete op.originalStructure;
  delete op.reader;
  delete op.sync;

  var exp =
  {
    'filePath' : a.abs( 'Pixels-2x2.png' ),
    'format' : 'png',
    'ext' : 'png',
    'special' : { 'interlaced' : false },
    'channelsMap' :
    {
      'red' : { 'name' : 'red', 'bits' : 8, 'order' : 0 },
      'green' : { 'name' : 'green', 'bits' : 8, 'order' : 1 },
      'blue' : { 'name' : 'blue', 'bits' : 8, 'order' : 2 },
      'alpha' : { 'name' : 'alpha', 'bits' : 8, 'order' : 3 }
    },
    'channelsArray' : [ 'red', 'green', 'blue', 'alpha' ],
    'buffer' : ( new U8x([ 0xff, 0x0, 0x0, 0xff, 0x0, 0xff, 0x0, 0xff, 0x0, 0x0, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff ]) ).buffer,
    'dims' : [ 2, 2 ],
    'bytesPerPixel' : 4,
    'bitsPerPixel' : 32,
    'hasPalette' : false,
    'readerClass' : _.image.reader.Pngjs,
  }

  test.identical( op, exp );

  /* */

  test.case = 'options map';

  a.reflect();

  var op = _.image.fileRead({ filePath : a.abs( 'Pixels-2x2.png' ), sync : 1 });

  test.is( _.bufferRawIs( op.data ) );

  delete op.data;
  delete op.originalStructure;
  delete op.reader;
  delete op.sync;

  var exp =
  {
    'filePath' : a.abs( 'Pixels-2x2.png' ),
    'format' : 'png',
    'ext' : 'png',
    'special' : { 'interlaced' : false },
    'channelsMap' :
    {
      'red' : { 'name' : 'red', 'bits' : 8, 'order' : 0 },
      'green' : { 'name' : 'green', 'bits' : 8, 'order' : 1 },
      'blue' : { 'name' : 'blue', 'bits' : 8, 'order' : 2 },
      'alpha' : { 'name' : 'alpha', 'bits' : 8, 'order' : 3 }
    },
    'channelsArray' : [ 'red', 'green', 'blue', 'alpha' ],
    'buffer' : ( new U8x([ 0xff, 0x0, 0x0, 0xff, 0x0, 0xff, 0x0, 0xff, 0x0, 0x0, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff ]) ).buffer,
    'dims' : [ 2, 2 ],
    'bytesPerPixel' : 4,
    'bitsPerPixel' : 32,
    'hasPalette' : false,
    'readerClass' : _.image.reader.Pngjs,
  }

  test.identical( op, exp );

  /* */

}

//

function fileReadAsync( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );

  /* */

  a.ready.then( () =>
  {

    test.case = 'basic';

    a.reflect();
    var op = _.image.fileRead({ filePath : a.abs( 'Pixels-2x2.png' ), sync : 0 });
    test.is( _.consequenceIs( op ) );

    return op;
  })

  a.ready.then( ( op ) =>
  {

    test.is( _.bufferRawIs( op.data ) );

    delete op.data;
    delete op.originalStructure;
    delete op.reader;
    delete op.sync;

    var exp =
    {
      'filePath' : a.abs( 'Pixels-2x2.png' ),
      'format' : 'png',
      'ext' : 'png',
      'special' : { 'interlaced' : false },
      'channelsMap' :
      {
        'red' : { 'name' : 'red', 'bits' : 8, 'order' : 0 },
        'green' : { 'name' : 'green', 'bits' : 8, 'order' : 1 },
        'blue' : { 'name' : 'blue', 'bits' : 8, 'order' : 2 },
        'alpha' : { 'name' : 'alpha', 'bits' : 8, 'order' : 3 }
      },
      'channelsArray' : [ 'red', 'green', 'blue', 'alpha' ],
      'buffer' : ( new U8x([ 0xff, 0x0, 0x0, 0xff, 0x0, 0xff, 0x0, 0xff, 0x0, 0x0, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff ]) ).buffer,
      'dims' : [ 2, 2 ],
      'bytesPerPixel' : 4,
      'bitsPerPixel' : 32,
      'hasPalette' : false,
      'readerClass' : _.image.reader.Pngjs,
    }

    test.identical( op, exp );

    return op;
  });

  /* */

  return a.ready;
}

// --
// declare
// --

var Proto =
{

  name : 'ImageRead',
  abstract : 0,
  silencing : 1,
  enabled : 1,
  verbosity : 4,

  onSuiteBegin,
  onSuiteEnd,

  context :
  {
    suiteTempPath : null,
    assetsOriginalPath : null,
    appJsPath : null,
  },

  tests :
  {
    fileReadSync,
    fileReadAsync
  },

}

//

var Self = new wTestSuite( Proto )
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
