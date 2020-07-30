( function _ReaderAbstract_test_s_( )
{

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../../wtools/Tools.s' );
  require( '../image/entry/Reader.s' );
  _.include( 'wTesting' );
}

let _ = _global_.wTools;

// --
// context
// --

function onSuiteBegin( test )
{
  let context = this;

  context.suiteTempPath = _.path.tempOpen( _.path.join( __dirname, '../..' ), 'ImageRead' );
  context.assetsOriginalPath = _.path.join( __dirname, '_assets' );

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

function readHeadBufferAsync( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  let callbacks = [];

  act({ encoding : 'buffer.raw', is : _.bufferRawIs });
  act({ encoding : 'buffer.node', is : _.bufferNodeIs });
  act({ encoding : 'buffer.bytes', is : _.bufferBytesIs });

  return a.ready;

  function act( o )
  {

    /* */

    a.ready.then( () =>
    {
      test.case = `src:${o.encoding}`;
      callbacks = [];
      a.reflect();
      var data = _.fileProvider.fileRead({ filePath : a.abs( `Pixels-2x2.${context.ext}` ), encoding : o.encoding });
      test.is( o.is( data ) );
      var op = _.image.readHead({ data, ext : context.ext, sync : 0, onHead });
      test.is( _.consequenceIs( op ) );
      return op;
    })

    a.ready.then( ( op ) =>
    {

      test.description = 'operation';

      test.is( o.is( op.data ) );
      test.is( op.reader instanceof op.readerClass );
      test.is( _.objectIs( op.originalStructure ) );

      delete op.data;
      delete op.originalStructure;
      delete op.reader;

      var exp =
      {
        'filePath' : null,
        'format' : context.format,
        'ext' : context.ext,
        'mode' : 'head',
        'sync' : 0,
        'readerClass' : _.image.reader[ context.readerName ],
        onHead,
        'headGot' : true,
        'structure' :
        {
          'buffer' : null,
          'special' : { 'interlaced' : false },
          'channelsMap' :
          {
            'red' : { 'name' : 'red', 'bits' : 8, 'order' : 0 },
            'green' : { 'name' : 'green', 'bits' : 8, 'order' : 1 },
            'blue' : { 'name' : 'blue', 'bits' : 8, 'order' : 2 },
            'alpha' : { 'name' : 'alpha', 'bits' : 8, 'order' : 3 }
          },
          'channelsArray' : [ 'red', 'green', 'blue', 'alpha' ],
          'dims' : [ 2, 2 ],
          'bytesPerPixel' : 4,
          'bitsPerPixel' : 32,
          'hasPalette' : false,
        }
      }

      test.identical( op, exp );

      test.description = 'onHead';
      test.is( callbacks[ 0 ] === op );
      test.identical( callbacks.length, 1 );

      return op;
    });

  }

  /* */

  function onHead( op )
  {
    callbacks.push( op );
  }

}

//

function readHeadStreamAsync( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  let callbacks = [];

  act({ encoding : 'buffer.raw', is : _.bufferRawIs });
  act({ encoding : 'buffer.node', is : _.bufferNodeIs });
  act({ encoding : 'buffer.bytes', is : _.bufferBytesIs });

  return a.ready;

  function act( o )
  {

    /* */

    a.ready.then( () =>
    {
      test.case = `src:${o.encoding}`;
      callbacks = [];
      a.reflect();
      var data = _.fileProvider.streamRead({ filePath : a.abs( `Pixels-2x2.${context.ext}` ), encoding : o.encoding });
      test.is( _.streamIs( data ) );
      var op = _.image.readHead({ data, ext : context.ext, sync : 0, onHead });
      test.is( _.consequenceIs( op ) );
      return op;
    })

    a.ready.then( ( op ) =>
    {

      test.description = 'operation';

      test.is( _.streamIs( op.data ) );
      test.is( op.reader instanceof op.readerClass );
      test.is( _.objectIs( op.originalStructure ) );

      delete op.data;
      delete op.originalStructure;
      delete op.reader;

      var exp =
      {
        'filePath' : null,
        'format' : context.format,
        'ext' : context.ext,
        'mode' : 'head',
        'sync' : 0,
        'readerClass' : _.image.reader[ context.readerName ],
        onHead,
        'headGot' : true,
        'structure' :
        {
          'buffer' : null,
          'special' : { 'interlaced' : false },
          'channelsMap' :
          {
            'red' : { 'name' : 'red', 'bits' : 8, 'order' : 0 },
            'green' : { 'name' : 'green', 'bits' : 8, 'order' : 1 },
            'blue' : { 'name' : 'blue', 'bits' : 8, 'order' : 2 },
            'alpha' : { 'name' : 'alpha', 'bits' : 8, 'order' : 3 }
          },
          'channelsArray' : [ 'red', 'green', 'blue', 'alpha' ],
          'dims' : [ 2, 2 ],
          'bytesPerPixel' : 4,
          'bitsPerPixel' : 32,
          'hasPalette' : false,
        }
      }

      test.identical( op, exp );

      test.description = 'onHead';
      test.is( callbacks[ 0 ] === op );
      test.identical( callbacks.length, 1 );

      return op;
    });

  }

  /* */

  function onHead( op )
  {
    callbacks.push( op );
  }

}

//

function readHeadBufferSync( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  let callbacks = [];

  act({ encoding : 'buffer.raw', is : _.bufferRawIs });
  act({ encoding : 'buffer.node', is : _.bufferNodeIs });
  act({ encoding : 'buffer.bytes', is : _.bufferBytesIs });

  return a.ready;

  function act( o )
  {

    /* */

    test.case = `src:${o.encoding}`;
    callbacks = [];
    a.reflect();
    var data = _.fileProvider.fileRead({ filePath : a.abs( `Pixels-2x2.${context.ext}` ), encoding : o.encoding });
    test.is( o.is( data ) );
    var op = _.image.readHead({ data, ext : context.ext, sync : 1, onHead });

    test.description = 'operation';

    test.is( o.is( op.data ) );
    test.is( op.reader instanceof op.readerClass );
    test.is( _.objectIs( op.originalStructure ) );

    delete op.data;
    delete op.originalStructure;
    delete op.reader;

    var exp =
    {
      'filePath' : null,
      'format' : context.format,
      'ext' : context.ext,
      'mode' : 'head',
      'sync' : 1,
      'readerClass' : _.image.reader[ context.readerName ],
      onHead,
      'headGot' : true,
      'structure' :
      {
        'buffer' : null,
        'special' : { 'interlaced' : false },
        'channelsMap' :
        {
          'red' : { 'name' : 'red', 'bits' : 8, 'order' : 0 },
          'green' : { 'name' : 'green', 'bits' : 8, 'order' : 1 },
          'blue' : { 'name' : 'blue', 'bits' : 8, 'order' : 2 },
          'alpha' : { 'name' : 'alpha', 'bits' : 8, 'order' : 3 }
        },
        'channelsArray' : [ 'red', 'green', 'blue', 'alpha' ],
        'dims' : [ 2, 2 ],
        'bytesPerPixel' : 4,
        'bitsPerPixel' : 32,
        'hasPalette' : false,
      }
    }

    test.identical( op, exp );

    test.description = 'onHead';
    test.is( callbacks[ 0 ] === op );
    test.identical( callbacks.length, 1 );

  }

  /* */

  function onHead( op )
  {
    callbacks.push( op );
  }

}

//

function readHeadStreamSync( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  let callbacks = [];

  act({ encoding : 'buffer.raw', is : _.bufferRawIs });
  act({ encoding : 'buffer.node', is : _.bufferNodeIs });
  act({ encoding : 'buffer.bytes', is : _.bufferBytesIs });

  return a.ready;

  function act( o )
  {

    /* */

    test.case = `src:${o.encoding}`;
    callbacks = [];
    a.reflect();
    var data = _.fileProvider.streamRead({ filePath : a.abs( `Pixels-2x2.${context.ext}` ), encoding : o.encoding });
    test.is( _.streamIs( data ) );
    var op = _.image.readHead({ data, ext : context.ext, sync : 1, onHead });

    test.description = 'operation';

    test.is( _.streamIs( data ) );
    test.is( op.reader instanceof op.readerClass );
    test.is( _.objectIs( op.originalStructure ) );

    delete op.data;
    delete op.originalStructure;
    delete op.reader;

    var exp =
    {
      'filePath' : null,
      'format' : context.format,
      'ext' : context.ext,
      'mode' : 'head',
      'sync' : 1,
      'readerClass' : _.image.reader[ context.readerName ],
      onHead,
      'headGot' : true,
      'structure' :
      {
        'buffer' : null,
        'special' : { 'interlaced' : false },
        'channelsMap' :
        {
          'red' : { 'name' : 'red', 'bits' : 8, 'order' : 0 },
          'green' : { 'name' : 'green', 'bits' : 8, 'order' : 1 },
          'blue' : { 'name' : 'blue', 'bits' : 8, 'order' : 2 },
          'alpha' : { 'name' : 'alpha', 'bits' : 8, 'order' : 3 }
        },
        'channelsArray' : [ 'red', 'green', 'blue', 'alpha' ],
        'dims' : [ 2, 2 ],
        'bytesPerPixel' : 4,
        'bitsPerPixel' : 32,
        'hasPalette' : false,
      }
    }

    test.identical( op, exp );

    test.description = 'onHead';
    test.is( callbacks[ 0 ] === op );
    test.identical( callbacks.length, 1 );

  }

  /* */

  function onHead( op )
  {
    callbacks.push( op );
  }

}

//

function readBufferAsync( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  let callbacks = [];

  act({ encoding : 'buffer.raw', is : _.bufferRawIs });
  act({ encoding : 'buffer.node', is : _.bufferNodeIs });
  act({ encoding : 'buffer.bytes', is : _.bufferBytesIs });

  return a.ready;

  function act( o )
  {

    /* */

    a.ready.then( () =>
    {
      test.case = `src:${o.encoding}`;
      callbacks = [];
      a.reflect();
      var data = _.fileProvider.fileRead({ filePath : a.abs( `Pixels-2x2.${context.ext}` ), encoding : o.encoding });
      test.is( o.is( data ) );
      var op = _.image.read({ data, ext : context.ext, sync : 0, onHead });
      test.is( _.consequenceIs( op ) );
      return op;
    })

    a.ready.then( ( op ) =>
    {

      test.description = 'operation';

      test.is( o.is( op.data ) );
      test.is( op.reader instanceof op.readerClass );
      test.is( _.objectIs( op.originalStructure ) );

      delete op.data;
      delete op.originalStructure;
      delete op.reader;

      var exp =
      {
        'filePath' : null,
        'format' : context.format,
        'ext' : context.ext,
        'mode' : 'full',
        'sync' : 0,
        'readerClass' : _.image.reader[ context.readerName ],
        onHead,
        'headGot' : true,
        'structure' :
        {
          'buffer' : ( new U8x([ 0xff, 0x0, 0x0, 0xff, 0x0, 0xff, 0x0, 0xff, 0x0, 0x0, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff ]) ).buffer,
          'special' : { 'interlaced' : false },
          'channelsMap' :
          {
            'red' : { 'name' : 'red', 'bits' : 8, 'order' : 0 },
            'green' : { 'name' : 'green', 'bits' : 8, 'order' : 1 },
            'blue' : { 'name' : 'blue', 'bits' : 8, 'order' : 2 },
            'alpha' : { 'name' : 'alpha', 'bits' : 8, 'order' : 3 }
          },
          'channelsArray' : [ 'red', 'green', 'blue', 'alpha' ],
          'dims' : [ 2, 2 ],
          'bytesPerPixel' : 4,
          'bitsPerPixel' : 32,
          'hasPalette' : false,
        }
      }

      test.identical( op, exp );

      test.description = 'onHead';
      test.is( callbacks[ 0 ] === op );
      test.identical( callbacks.length, 1 );

      return op;
    });

  }

  /* */

  function onHead( op )
  {
    callbacks.push( op );
  }

}

//

function readStreamAsync( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  let callbacks = [];

  // act({ encoding : 'buffer.raw', is : _.bufferRawIs });
  // act({ encoding : 'buffer.node', is : _.bufferNodeIs });
  act({ encoding : 'buffer.bytes', is : _.bufferBytesIs });

  return a.ready;

  function act( o )
  {

    /* */

    a.ready.then( () =>
    {
      test.case = `src:${o.encoding}`;
      callbacks = [];
      a.reflect();
      var data = _.fileProvider.streamRead({ filePath : a.abs( `Pixels-2x2.${context.ext}` ), encoding : o.encoding });
      test.is( _.streamIs( data ) );
      var op = _.image.read({ data, ext : context.ext, sync : 0, onHead });
      test.is( _.consequenceIs( op ) );
      return op;
    })

    a.ready.then( ( op ) =>
    {

      test.description = 'operation';

      test.is( _.streamIs( op.data ) );
      test.is( op.reader instanceof op.readerClass );
      test.is( _.objectIs( op.originalStructure ) );

      delete op.data;
      delete op.originalStructure;
      delete op.reader;

      var exp =
      {
        'filePath' : null,
        'format' : context.format,
        'ext' : context.ext,
        'mode' : 'full',
        'sync' : 0,
        'readerClass' : _.image.reader[ context.readerName ],
        onHead,
        'headGot' : true,
        'structure' :
        {
          'buffer' : ( new U8x([ 0xff, 0x0, 0x0, 0xff, 0x0, 0xff, 0x0, 0xff, 0x0, 0x0, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff ]) ).buffer,
          'special' : { 'interlaced' : false },
          'channelsMap' :
          {
            'red' : { 'name' : 'red', 'bits' : 8, 'order' : 0 },
            'green' : { 'name' : 'green', 'bits' : 8, 'order' : 1 },
            'blue' : { 'name' : 'blue', 'bits' : 8, 'order' : 2 },
            'alpha' : { 'name' : 'alpha', 'bits' : 8, 'order' : 3 }
          },
          'channelsArray' : [ 'red', 'green', 'blue', 'alpha' ],
          'dims' : [ 2, 2 ],
          'bytesPerPixel' : 4,
          'bitsPerPixel' : 32,
          'hasPalette' : false,
        }
      }

      test.identical( op, exp );

      test.description = 'onHead';
      test.is( callbacks[ 0 ] === op );
      test.identical( callbacks.length, 1 );

      return op;
    });

  }

  /* */

  function onHead( op )
  {
    callbacks.push( op );
  }

}

//

function readBufferSync( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  let callbacks = [];

  act({ encoding : 'buffer.raw', is : _.bufferRawIs });
  act({ encoding : 'buffer.node', is : _.bufferNodeIs });
  act({ encoding : 'buffer.bytes', is : _.bufferBytesIs });

  return a.ready;

  function act( o )
  {

    /* */

    test.case = `src:${o.encoding}`;
    callbacks = [];
    a.reflect();
    var data = _.fileProvider.fileRead({ filePath : a.abs( `Pixels-2x2.${context.ext}` ), encoding : o.encoding });
    test.is( o.is( data ) );
    var op = _.image.read({ data, ext : context.ext, sync : 1, onHead });

    test.description = 'operation';

    test.is( o.is( op.data ) );
    test.is( op.reader instanceof op.readerClass );
    test.is( _.objectIs( op.originalStructure ) );

    delete op.data;
    delete op.originalStructure;
    delete op.reader;

    var exp =
    {
      'filePath' : null,
      'format' : context.format,
      'ext' : context.ext,
      'mode' : 'full',
      'sync' : 1,
      'readerClass' : _.image.reader[ context.readerName ],
      onHead,
      'headGot' : true,
      'structure' :
      {
        'buffer' : ( new U8x([ 0xff, 0x0, 0x0, 0xff, 0x0, 0xff, 0x0, 0xff, 0x0, 0x0, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff ]) ).buffer,
        'special' : { 'interlaced' : false },
        'channelsMap' :
        {
          'red' : { 'name' : 'red', 'bits' : 8, 'order' : 0 },
          'green' : { 'name' : 'green', 'bits' : 8, 'order' : 1 },
          'blue' : { 'name' : 'blue', 'bits' : 8, 'order' : 2 },
          'alpha' : { 'name' : 'alpha', 'bits' : 8, 'order' : 3 }
        },
        'channelsArray' : [ 'red', 'green', 'blue', 'alpha' ],
        'dims' : [ 2, 2 ],
        'bytesPerPixel' : 4,
        'bitsPerPixel' : 32,
        'hasPalette' : false,
      }
    }

    test.identical( op, exp );

    test.description = 'onHead';
    test.is( callbacks[ 0 ] === op );
    test.identical( callbacks.length, 1 );

  }

  /* */

  function onHead( op )
  {
    callbacks.push( op );
  }

}

//

function readStreamSync( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  let callbacks = [];

  act({ encoding : 'buffer.raw', is : _.bufferRawIs });
  act({ encoding : 'buffer.node', is : _.bufferNodeIs });
  act({ encoding : 'buffer.bytes', is : _.bufferBytesIs });

  return a.ready;

  function act( o )
  {

    /* */

    test.case = `src:${o.encoding}`;
    callbacks = [];
    a.reflect();
    var data = _.fileProvider.streamRead({ filePath : a.abs( `Pixels-2x2.${context.ext}` ), encoding : o.encoding });
    test.is( _.streamIs( data ) );
    var op = _.image.read({ data, ext : context.ext, sync : 1, onHead });

    test.description = 'operation';

    test.is( _.streamIs( data ) );
    test.is( op.reader instanceof op.readerClass );
    test.is( _.objectIs( op.originalStructure ) );

    delete op.data;
    delete op.originalStructure;
    delete op.reader;

    var exp =
    {
      'filePath' : null,
      'format' : context.format,
      'ext' : context.ext,
      'mode' : 'full',
      'sync' : 1,
      'readerClass' : _.image.reader[ context.readerName ],
      onHead,
      'headGot' : true,
      'structure' :
      {
        'buffer' : ( new U8x([ 0xff, 0x0, 0x0, 0xff, 0x0, 0xff, 0x0, 0xff, 0x0, 0x0, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff ]) ).buffer,
        'special' : { 'interlaced' : false },
        'channelsMap' :
        {
          'red' : { 'name' : 'red', 'bits' : 8, 'order' : 0 },
          'green' : { 'name' : 'green', 'bits' : 8, 'order' : 1 },
          'blue' : { 'name' : 'blue', 'bits' : 8, 'order' : 2 },
          'alpha' : { 'name' : 'alpha', 'bits' : 8, 'order' : 3 }
        },
        'channelsArray' : [ 'red', 'green', 'blue', 'alpha' ],
        'dims' : [ 2, 2 ],
        'bytesPerPixel' : 4,
        'bitsPerPixel' : 32,
        'hasPalette' : false,
      }
    }

    test.identical( op, exp );

    test.description = 'onHead';
    test.is( callbacks[ 0 ] === op );
    test.identical( callbacks.length, 1 );

  }

  /* */

  function onHead( op )
  {
    callbacks.push( op );
  }

}

//

function fileReadHeadSync( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  let callbacks = [];

  /* */

  test.case = 'basic';

  a.reflect();
  var op = _.image.fileReadHead({ filePath : a.abs( `Pixels-2x2.${context.ext}` ), sync : 1, onHead });
  test.is( _.mapIs( op ) );

  test.description = 'operation';

  test.is( _.streamIs( op.data ) );
  test.is( op.reader instanceof op.readerClass );
  test.is( _.objectIs( op.originalStructure ) );

  delete op.data;
  delete op.originalStructure;
  delete op.reader;

  var exp =
  {
    'filePath' : a.abs( `Pixels-2x2.${context.ext}` ),
    'format' : context.format,
    'ext' : context.ext,
    'mode' : 'head',
    'sync' : 1,
    'readerClass' : _.image.reader[ context.readerName ],
    onHead,
    'headGot' : true,
    'structure' :
    {
      'buffer' : null,
      'special' : { 'interlaced' : false },
      'channelsMap' :
      {
        'red' : { 'name' : 'red', 'bits' : 8, 'order' : 0 },
        'green' : { 'name' : 'green', 'bits' : 8, 'order' : 1 },
        'blue' : { 'name' : 'blue', 'bits' : 8, 'order' : 2 },
        'alpha' : { 'name' : 'alpha', 'bits' : 8, 'order' : 3 }
      },
      'channelsArray' : [ 'red', 'green', 'blue', 'alpha' ],
      'dims' : [ 2, 2 ],
      'bytesPerPixel' : 4,
      'bitsPerPixel' : 32,
      'hasPalette' : false,
    }
  }

  test.identical( op, exp );

  test.description = 'onHead';
  test.is( callbacks[ 0 ] === op );
  test.identical( callbacks.length, 1 );

  /* */

  function onHead( op )
  {
    callbacks.push( op );
  }

}

//

function fileReadHeadAsync( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  let callbacks = [];

  /* */

  a.ready.then( () =>
  {
    test.case = 'basic';
    a.reflect();
    var op = _.image.fileReadHead({ filePath : a.abs( `Pixels-2x2.${context.ext}` ), sync : 0, onHead });
    test.is( _.consequenceIs( op ) );
    return op;
  })

  a.ready.then( ( op ) =>
  {

    test.description = 'operation';

    test.is( _.streamIs( op.data ) );
    test.is( op.reader instanceof op.readerClass );
    test.is( _.objectIs( op.originalStructure ) );

    delete op.data;
    delete op.originalStructure;
    delete op.reader;

    var exp =
    {
      'filePath' : a.abs( `Pixels-2x2.${context.ext}` ),
      'format' : context.format,
      'ext' : context.ext,
      'mode' : 'head',
      'sync' : 0,
      'readerClass' : _.image.reader[ context.readerName ],
      onHead,
      'headGot' : true,
      'structure' :
      {
        'buffer' : null,
        'special' : { 'interlaced' : false },
        'channelsMap' :
        {
          'red' : { 'name' : 'red', 'bits' : 8, 'order' : 0 },
          'green' : { 'name' : 'green', 'bits' : 8, 'order' : 1 },
          'blue' : { 'name' : 'blue', 'bits' : 8, 'order' : 2 },
          'alpha' : { 'name' : 'alpha', 'bits' : 8, 'order' : 3 }
        },
        'channelsArray' : [ 'red', 'green', 'blue', 'alpha' ],
        'dims' : [ 2, 2 ],
        'bytesPerPixel' : 4,
        'bitsPerPixel' : 32,
        'hasPalette' : false,
      }
    }

    test.identical( op, exp );

    test.description = 'onHead';
    test.is( callbacks[ 0 ] === op );
    test.identical( callbacks.length, 1 );

    return op;
  });

  /* */

  return a.ready;

  function onHead( op )
  {
    callbacks.push( op );
  }

}

//

function fileReadSync( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  let callbacks = [];

  /* */

  test.case = 'single path';

  a.reflect();

  var op = _.image.fileRead( a.abs( `Pixels-2x2.${context.ext}` ) );

  test.description = 'operation';

  test.is( _.bufferRawIs( op.data ) );
  test.is( op.reader instanceof op.readerClass );
  test.is( _.objectIs( op.originalStructure ) );

  delete op.data;
  delete op.originalStructure;
  delete op.reader;

  var exp =
  {
    'filePath' : a.abs( `Pixels-2x2.${context.ext}` ),
    'format' : context.format,
    'ext' : context.ext,
    'readerClass' : _.image.reader[ context.readerName ],
    'mode' : 'full',
    'sync' : 1,
    'onHead' : null,
    'headGot' : true,
    'structure' :
    {
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
    }
  }

  test.identical( op, exp );

  /* */

  test.case = 'options map';

  a.reflect();
  callbacks = [];

  var op = _.image.fileRead({ filePath : a.abs( `Pixels-2x2.${context.ext}` ), sync : 1, onHead });

  test.description = 'operation';

  test.is( _.bufferRawIs( op.data ) );
  test.is( op.reader instanceof op.readerClass );
  test.is( _.objectIs( op.originalStructure ) );

  delete op.data;
  delete op.originalStructure;
  delete op.reader;

  var exp =
  {
    'filePath' : a.abs( `Pixels-2x2.${context.ext}` ),
    'format' : context.format,
    'ext' : context.ext,
    'readerClass' : _.image.reader[ context.readerName ],
    'mode' : 'full',
    'sync' : 1,
    onHead,
    'headGot' : true,
    'structure' :
    {
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
    }
  }

  test.identical( op, exp );

  test.description = 'onHead';
  test.is( callbacks[ 0 ] === op );
  test.identical( callbacks.length, 1 );

  /* */

  function onHead( op )
  {
    callbacks.push( op );
  }

}

//

function fileReadAsync( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  let callbacks = [];

  /* */

  a.ready.then( () =>
  {

    test.case = 'basic';

    a.reflect();
    var op = _.image.fileRead({ filePath : a.abs( `Pixels-2x2.${context.ext}` ), sync : 0, onHead });
    test.is( _.consequenceIs( op ) );

    return op;
  })

  a.ready.then( ( op ) =>
  {

    test.description = 'operation';

    test.is( _.bufferRawIs( op.data ) );
    test.is( op.reader instanceof op.readerClass );
    test.is( _.objectIs( op.originalStructure ) );

    delete op.data;
    delete op.originalStructure;
    delete op.reader;

    var exp =
    {
      'filePath' : a.abs( `Pixels-2x2.${context.ext}` ),
      'format' : context.format,
      'ext' : context.ext,
      'readerClass' : _.image.reader[ context.readerName ],
      'mode' : 'full',
      'sync' : 0,
      'headGot' : true,
      onHead,
      'structure' :
      {
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
      }
    }

    test.identical( op, exp );

    test.description = 'onHead';
    test.is( callbacks[ 0 ] === op );
    test.identical( callbacks.length, 1 );

    return op;
  });


  /* */

  return a.ready;

  /* */

  function onHead( op )
  {
    callbacks.push( op );
  }

}

//

function experiment( test )
{
  var fs = require( 'fs' );
  let context = this;
  let a = test.assetFor( 'png' );
  a.reflect();

  var dim = [ 59, 7 ];
  var colWidth = 26;
  var rowHeight = 4;
  var style = 'doubleBorder';

  var files = fs.readdirSync( 'D:\\programming\\BFS\\wImage\\wImage\\proto\\wtools\\amid\\l3\\image.test\\_assets\\png' );
  var dataHeader = [ 'Image Name', 'Dim', 'Chan&Bit', 'Buff', 'biPP', 'ByPP', 'Pal' ];
  var data = [ ... dataHeader ]

  for( let i = 0; i < files.length; i++ )
  {
    var res;
    var imgData = parseImg( files[ i ] );
    console.log( 'imgData: ', imgData )
    try
    {
      res = _.image.fileRead({ filePath : a.abs( files[ i ] ), sync : 1 });
    }
    catch( err )
    {
      data.push( files[ i ] );
      data.push( 'ERR' );
      data.push( 'ERR' );
      data.push( 'ERR' );
      data.push( 'ERR' );
      data.push( 'ERR' );
      data.push( 'ERR' );
      continue;
    }

    let channelsBits = [];
    data.push( files[ i ].slice( 7, 16 ) + '\n' + files[ i ].slice( 16 ) );
    data.push( res.structure.dims[ 0 ] + 'x' + res.structure.dims[ 1 ] );
    for( let k in res.structure.channelsMap )
    channelsBits.push( res.structure.channelsMap[ k ].name + ':' + res.structure.channelsMap[ k ].bits )
    data.push( channelsBits.join( '\n' ) );
    data.push( res.structure.buffer ? '+' : '-' );
    data.push( '' + res.structure.bitsPerPixel );
    data.push( '' + res.structure.bytesPerPixel );
    data.push( res.structure.hasPalette ? '+' : '-' );
  };
  debugger;
  var got = _.strTable({ data, dim, style, colWidth, rowHeight });
  console.log( got.result )

  test.identical( 1, 1 );

  function parseImg( str )
  {
    let arr = str.split( '-' ).slice( 1 );
    let img =
    {
      dims : arr[ 0 ].split( 'x' ).map( ( el ) => +el ),
      depth : +arr[ 1 ].slice( 5 ),
      interlaced : arr[ 2 ] === 'interlaced1',
      channels : arr[ 3 ].split( '.' )[ 0 ].length > 4 ? 'palette' : arr[ 3 ].split( '.' )[ 0 ].length
    }
    return img;
  }
}

experiment.experimental = true;

// --
// declare
// --

var Proto =
{

  name : 'ImageReadAbstract',
  abstract : 1,
  silencing : 1,

  onSuiteBegin,
  onSuiteEnd,

  context :
  {
    suiteTempPath : null,
    assetsOriginalPath : null,
    appJsPath : null,
    ext : null,
    format : null,
    readerName : null
  },

  tests :
  {

    readHeadBufferAsync,
    readHeadStreamAsync,
    readHeadBufferSync,
    readHeadStreamSync,

    readBufferAsync,
    readStreamAsync,
    readBufferSync,
    readStreamSync,

    fileReadHeadSync,
    fileReadHeadAsync,
    fileReadSync,
    fileReadAsync,

    experiment

  },

}

//

let Self = new wTestSuite( Proto )
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
