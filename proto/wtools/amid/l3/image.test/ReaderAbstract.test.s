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

function encode( test )
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
    test.true( o.is( data ) );

    test.description = 'operation';

    var params = {}
    var encoder = _.gdf.selectSingleContext({ ext : context.ext })
    var op = encoder.encode({ data : data, params });
    test.true( o.is( op.in.data ) );
    test.true( _.objectIs( op.params.originalStructure ) );

    var exp =
    {
      'in' :
      {
        'data' : op.in.data,
        'filePath' : null,
        'ext' : null,
        'format' : 'buffer.png'
      },
      'out' :
      {
        'data' :
        {
          'buffer' : ( new U8x([ 0xff, 0x0, 0x0, 0xff, 0x0, 0xff, 0x0, 0xff, 0x0, 0x0, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff ]) ).buffer,
          'special' : { 'interlaced' : false },
          'channelsMap' :
          {
            'red' : { 'name' : 'red', 'bits' : 8, 'order' : 0 },
            'green' : { 'name' : 'green', 'bits' : 8, 'order' : 1 },
            'blue' : { 'name' : 'blue', 'bits' : 8, 'order' : 2 },
            'alpha' : { 'name' : 'alpha', 'bits' : 8, 'order' : 3 },
          },
          'channelsArray' : [ 'red', 'green', 'blue', 'alpha' ],
          'dims' : [ 2, 2 ],
          'bytesPerPixel' : 4,
          'bitsPerPixel' : 32,
          'hasPalette' : false,
        },
        'format' : 'structure.image',
      },
      'params' :
      {
        'mode' : 'full',
        'headGot' : true,
        'originalStructure' : op.params.originalStructure,
      },
      'sync' : true,
      'err' : null,
    }

    test.identical( op, exp );

  }

  /* */

}

//

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
      test.true( o.is( data ) );
      var op = _.image.readHead({ data, ext : context.ext, sync : 0, onHead });
      test.true( _.consequenceIs( op ) );
      return op;
    })

    a.ready.then( ( op ) =>
    {
      test.description = 'operation';

      test.true( o.is( op.in.data ) );
      test.true( _.objectIs( op.params.originalStructure ) );

      var exp =
      {
        'in' :
        {
          'data' : op.in.data,
          'filePath' : null,
          'ext' : 'png',
          'format' : 'buffer.png'
        },
        'out' :
        {
          'data' :
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
          },
          'format' : 'structure.image',
        },
        'params' :
        {
          'onHead' : onHead,
          'mode' : 'head',
          'headGot' : true,
          'originalStructure' : op.params.originalStructure,
        },
        'sync' : 0,
        'err' : null,
      }

      test.identical( op, exp );

      test.description = 'onHead';
      test.true( callbacks[ 0 ] === op );
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
      test.true( _.streamIs( data ) );
      var op = _.image.readHead({ data, ext : context.ext, sync : 0, onHead });
      test.true( _.consequenceIs( op ) );
      return op;
    })

    a.ready.then( ( op ) =>
    {

      test.description = 'operation';

      test.true( _.streamIs( op.in.data ) );
      test.true( _.objectIs( op.params.originalStructure ) );

      var exp =
      {
        'in' :
        {
          'data' : op.in.data,
          'filePath' : null,
          'ext' : 'png',
          'format' : 'stream.png'
        },
        'out' :
        {
          'data' :
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
          },
          'format' : 'structure.image',
        },
        'params' :
        {
          'onHead' : onHead,
          'mode' : 'head',
          'headGot' : true,
          'originalStructure' : op.params.originalStructure,
        },
        'sync' : 0,
        'err' : null
      }

      test.identical( op, exp );

      test.description = 'onHead';
      test.true( callbacks[ 0 ] === op );
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
    test.true( o.is( data ) );
    var op = _.image.readHead({ data, ext : context.ext, sync : 1, onHead });

    test.description = 'operation';

    test.true( o.is( op.in.data ) );
    test.true( _.objectIs( op.params.originalStructure ) );

    var exp =
    {
      'in' :
      {
        'data' : op.in.data,
        'filePath' : null,
        'ext' : 'png',
        'format' : 'buffer.png'
      },
      'out' :
      {
        'data' :
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
        },
        'format' : 'structure.image',
      },
      'params' :
      {
        'onHead' : onHead,
        'mode' : 'head',
        'headGot' : true,
        'originalStructure' : op.params.originalStructure,
      },
      'sync' : 1,
      'err' : null
    }

    test.identical( op, exp );

    test.description = 'onHead';
    test.true( callbacks[ 0 ] === op );
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
    test.true( _.streamIs( data ) );
    var op = _.image.readHead({ data, ext : context.ext, sync : 1, onHead });

    test.description = 'operation';

    test.true( _.streamIs( data ) );
    test.true( _.objectIs( op.params.originalStructure ) );

    var exp =
    {
      'in' :
      {
        'data' : op.in.data,
        'filePath' : null,
        'ext' : 'png',
        'format' : 'stream.png'
      },
      'out' :
      {
        'data' :
        {
          'special' : { 'interlaced' : false },
          'channelsMap' :
          {
            'red' : { 'name' : 'red', 'bits' : 8, 'order' : 0 },
            'green' : { 'name' : 'green', 'bits' : 8, 'order' : 1 },
            'blue' : { 'name' : 'blue', 'bits' : 8, 'order' : 2 },
            'alpha' : { 'name' : 'alpha', 'bits' : 8, 'order' : 3 },
          },
          'channelsArray' : [ 'red', 'green', 'blue', 'alpha' ],
          'buffer' : null,
          'dims' : [ 2, 2 ],
          'bytesPerPixel' : 4,
          'bitsPerPixel' : 32,
          'hasPalette' : false,
        },
        'format' : 'structure.image',
      },
      'params' :
      {
        'onHead' : onHead,
        'mode' : 'head',
        'headGot' : true,
        'originalStructure' : op.params.originalStructure,
      },
      'sync' : 1,
      'err' : null,
    }

    test.identical( op, exp );

    test.description = 'onHead';
    test.true( callbacks[ 0 ] === op );
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
      test.true( o.is( data ) );
      var op = _.image.read({ data, ext : context.ext, sync : 0, onHead });
      test.true( _.consequenceIs( op ) );
      return op;
    })

    a.ready.then( ( op ) =>
    {
      test.description = 'operation';

      test.true( o.is( op.in.data ) );
      test.true( _.objectIs( op.params.originalStructure ) );

      var exp =
      {
        'in' :
        {
          'data' : op.in.data,
          'filePath' : null,
          'ext' : 'png',
          'format' : 'buffer.png'
        },
        'out' :
        {
          'data' :
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
          },
          'format' : 'structure.image',
        },
        'params' :
        {
          'onHead' : onHead,
          'mode' : 'full',
          'headGot' : true,
          'originalStructure' : op.params.originalStructure,
        },
        'sync' : 0,
        'err' : null
      }

      test.identical( op, exp );

      test.description = 'onHead';
      test.true( callbacks[ 0 ] === op );
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
      test.true( _.streamIs( data ) );
      var op = _.image.read({ data, ext : context.ext, sync : 0, onHead });
      test.true( _.consequenceIs( op ) );
      return op;
    })

    a.ready.then( ( op ) =>
    {
      test.description = 'operation';

      test.true( _.streamIs( op.in.data ) );
      test.true( _.objectIs( op.params.originalStructure ) );

      var exp =
      {
        'in' :
        {
          'data' : op.in.data,
          'filePath' : null,
          'ext' : 'png',
          'format' : 'stream.png'
        },
        'out' :
        {
          'data' :
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
          },
          'format' : 'structure.image',
        },
        'params' :
        {
          'onHead' : onHead,
          'mode' : 'full',
          'headGot' : true,
          'originalStructure' : op.params.originalStructure,
        },
        'sync' : 0,
        'err' : null
      }

      test.identical( op, exp );

      test.description = 'onHead';
      test.true( callbacks[ 0 ] === op );
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
    test.true( o.is( data ) );

    debugger;
    var op = _.image.read({ data, ext : context.ext, sync : 1, onHead });
    debugger;

    test.description = 'operation';

    test.true( o.is( op.in.data ) );
    test.true( _.objectIs( op.params.originalStructure ) );

    var exp =
    {
      'in' :
      {
        'data' : op.in.data,
        'filePath' : null,
        'ext' : 'png',
        'format' : 'buffer.png'
      },
      'out' :
      {
        'data' :
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
        },
        'format' : 'structure.image',
      },
      'params' :
      {
        'onHead' : onHead,
        'mode' : 'full',
        'headGot' : true,
        'originalStructure' : op.params.originalStructure,
      },
      'sync' : 1,
      'err' : null
    }

    test.identical( op, exp );

    test.description = 'onHead';
    test.true( callbacks[ 0 ] === op );
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
    test.true( _.streamIs( data ) );
    var op = _.image.read({ data, ext : context.ext, sync : 1, onHead });

    test.description = 'operation';

    test.true( _.streamIs( data ) );
    test.true( _.objectIs( op.params.originalStructure ) );

    var exp =
    {
      'in' :
      {
        'data' : op.in.data,
        'filePath' : null,
        'ext' : 'png',
        'format' : 'stream.png'
      },
      'out' :
      {
        'data' :
        {
          'special' : { 'interlaced' : false },
          'channelsMap' :
          {
            'red' : { 'name' : 'red', 'bits' : 8, 'order' : 0 },
            'green' : { 'name' : 'green', 'bits' : 8, 'order' : 1 },
            'blue' : { 'name' : 'blue', 'bits' : 8, 'order' : 2 },
            'alpha' : { 'name' : 'alpha', 'bits' : 8, 'order' : 3 },
          },
          'channelsArray' : [ 'red', 'green', 'blue', 'alpha' ],
          'buffer' : ( new U8x([ 0xff, 0x0, 0x0, 0xff, 0x0, 0xff, 0x0, 0xff, 0x0, 0x0, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff ]) ).buffer,
          'dims' : [ 2, 2 ],
          'bytesPerPixel' : 4,
          'bitsPerPixel' : 32,
          'hasPalette' : false,
        },
        'format' : 'structure.image',
      },
      'params' :
      {
        'onHead' : onHead,
        'mode' : 'full',
        'headGot' : true,
        'originalStructure' : op.params.originalStructure,
      },
      'sync' : 1,
      'err' : null,
    }

    test.identical( op, exp );

    test.description = 'onHead';
    test.true( callbacks[ 0 ] === op );
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
  test.true( _.mapIs( op ) );

  test.description = 'operation';

  test.true( _.streamIs( op.in.data ) );
  test.true( _.objectIs( op.params.originalStructure ) );

  var exp =
  {
    'in' :
    {
      'data' : op.in.data,
      'filePath' : a.abs( `Pixels-2x2.${context.ext}` ),
      'ext' : 'png',
      'format' : 'stream.png'
    },
    'out' :
    {
      'data' :
      {
        'special' : { 'interlaced' : false },
        'channelsMap' :
        {
          'red' : { 'name' : 'red', 'bits' : 8, 'order' : 0 },
          'green' : { 'name' : 'green', 'bits' : 8, 'order' : 1 },
          'blue' : { 'name' : 'blue', 'bits' : 8, 'order' : 2 },
          'alpha' : { 'name' : 'alpha', 'bits' : 8, 'order' : 3 },
        },
        'channelsArray' : [ 'red', 'green', 'blue', 'alpha' ],
        'buffer' : null,
        'dims' : [ 2, 2 ],
        'bytesPerPixel' : 4,
        'bitsPerPixel' : 32,
        'hasPalette' : false,
      },
      'format' : 'structure.image',
    },
    'params' :
    {
      'onHead' : onHead,
      'mode' : 'head',
      'headGot' : true,
      'originalStructure' : op.params.originalStructure,
    },
    'sync' : 1,
    'err' : null,
  }

  test.identical( op, exp );

  test.description = 'onHead';
  test.true( callbacks[ 0 ] === op );
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
    test.true( _.consequenceIs( op ) );
    return op;
  })

  a.ready.then( ( op ) =>
  {
    test.description = 'operation';

    test.true( _.streamIs( op.in.data ) );
    test.true( _.objectIs( op.params.originalStructure ) );

    var exp =
    {
      'in' :
      {
        'data' : op.in.data,
        'filePath' : a.abs( `Pixels-2x2.${context.ext}` ),
        'ext' : 'png',
        'format' : 'stream.png'
      },
      'out' :
      {
        'data' :
        {
          'special' : { 'interlaced' : false },
          'channelsMap' :
          {
            'red' : { 'name' : 'red', 'bits' : 8, 'order' : 0 },
            'green' : { 'name' : 'green', 'bits' : 8, 'order' : 1 },
            'blue' : { 'name' : 'blue', 'bits' : 8, 'order' : 2 },
            'alpha' : { 'name' : 'alpha', 'bits' : 8, 'order' : 3 },
          },
          'channelsArray' : [ 'red', 'green', 'blue', 'alpha' ],
          'buffer' : null,
          'dims' : [ 2, 2 ],
          'bytesPerPixel' : 4,
          'bitsPerPixel' : 32,
          'hasPalette' : false,
        },
        'format' : 'structure.image',
      },
      'params' :
      {
        'onHead' : onHead,
        'mode' : 'head',
        'headGot' : true,
        'originalStructure' : op.params.originalStructure,
      },
      'sync' : 0,
      'err' : null,
    }

    test.identical( op, exp );

    test.description = 'onHead';
    test.true( callbacks[ 0 ] === op );
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

  test.true( _.bufferRawIs( op.in.data ) );
  test.true( _.objectIs( op.params.originalStructure ) );

  var exp =
  {
    'in' :
    {
      'data' : op.in.data,
      'filePath' : a.abs( `Pixels-2x2.${context.ext}` ),
      'ext' : 'png',
      'format' : 'buffer.png'
    },
    'out' :
    {
      'data' :
      {
        'special' : { 'interlaced' : false },
        'channelsMap' :
        {
          'red' : { 'name' : 'red', 'bits' : 8, 'order' : 0 },
          'green' : { 'name' : 'green', 'bits' : 8, 'order' : 1 },
          'blue' : { 'name' : 'blue', 'bits' : 8, 'order' : 2 },
          'alpha' : { 'name' : 'alpha', 'bits' : 8, 'order' : 3 },
        },
        'channelsArray' : [ 'red', 'green', 'blue', 'alpha' ],
        'buffer' : ( new U8x([ 0xff, 0x0, 0x0, 0xff, 0x0, 0xff, 0x0, 0xff, 0x0, 0x0, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff ]) ).buffer,
        'dims' : [ 2, 2 ],
        'bytesPerPixel' : 4,
        'bitsPerPixel' : 32,
        'hasPalette' : false,
      },
      'format' : 'structure.image',
    },
    'params' :
    {
      'onHead' : null,
      'mode' : 'full',
      'headGot' : true,
      'originalStructure' : op.params.originalStructure,
    },
    'sync' : 1,
    'err' : null,
  }

  test.identical( op, exp );

  /* */

  test.case = 'options map';

  a.reflect();
  callbacks = [];

  var op = _.image.fileRead({ filePath : a.abs( `Pixels-2x2.${context.ext}` ), sync : 1, onHead });

  test.description = 'operation';

  test.true( _.bufferRawIs( op.in.data ) );
  test.true( _.objectIs( op.params.originalStructure ) );

  var exp =
  {
    'in' :
    {
      'data' : op.in.data,
      'filePath' : a.abs( `Pixels-2x2.${context.ext}` ),
      'ext' : 'png',
      'format' : 'buffer.png'
    },
    'out' :
    {
      'data' :
      {
        'special' : { 'interlaced' : false },
        'channelsMap' :
        {
          'red' : { 'name' : 'red', 'bits' : 8, 'order' : 0 },
          'green' : { 'name' : 'green', 'bits' : 8, 'order' : 1 },
          'blue' : { 'name' : 'blue', 'bits' : 8, 'order' : 2 },
          'alpha' : { 'name' : 'alpha', 'bits' : 8, 'order' : 3 },
        },
        'channelsArray' : [ 'red', 'green', 'blue', 'alpha' ],
        'buffer' : ( new U8x([ 0xff, 0x0, 0x0, 0xff, 0x0, 0xff, 0x0, 0xff, 0x0, 0x0, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff ]) ).buffer,
        'dims' : [ 2, 2 ],
        'bytesPerPixel' : 4,
        'bitsPerPixel' : 32,
        'hasPalette' : false,
      },
      'format' : 'structure.image',
    },
    'params' :
    {
      'onHead' : onHead,
      'mode' : 'full',
      'headGot' : true,
      'originalStructure' : op.params.originalStructure,
    },
    'sync' : 1,
    'err' : null,
  }

  test.identical( op, exp );

  test.description = 'onHead';
  test.true( callbacks[ 0 ] === op );
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
    test.true( _.consequenceIs( op ) );

    return op;
  })

  a.ready.then( ( op ) =>
  {

    test.description = 'operation';

    test.true( _.bufferRawIs( op.in.data ) );
    test.true( _.objectIs( op.params.originalStructure ) );

    var exp =
    {
      'in' :
      {
        'data' : op.in.data,
        'filePath' : a.abs( `Pixels-2x2.${context.ext}` ),
        'ext' : 'png',
        'format' : 'buffer.png',
      },
      'out' :
      {
        'data' :
        {
          'special' : { 'interlaced' : false },
          'channelsMap' :
          {
            'red' : { 'name' : 'red', 'bits' : 8, 'order' : 0 },
            'green' : { 'name' : 'green', 'bits' : 8, 'order' : 1 },
            'blue' : { 'name' : 'blue', 'bits' : 8, 'order' : 2 },
            'alpha' : { 'name' : 'alpha', 'bits' : 8, 'order' : 3 },
          },
          'channelsArray' : [ 'red', 'green', 'blue', 'alpha' ],
          'buffer' : ( new U8x([ 0xff, 0x0, 0x0, 0xff, 0x0, 0xff, 0x0, 0xff, 0x0, 0x0, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff ]) ).buffer,
          'dims' : [ 2, 2 ],
          'bytesPerPixel' : 4,
          'bitsPerPixel' : 32,
          'hasPalette' : false,
        },
        'format' : 'structure.image',
      },
      'params' :
      {
        'onHead' : onHead,
        'mode' : 'full',
        'headGot' : true,
        'originalStructure' : op.params.originalStructure,
      },
      'sync' : 0,
      'err' : null,
    }

    test.identical( op, exp );

    test.description = 'onHead';
    test.true( callbacks[ 0 ] === op );
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
    inFormat : null,
    readerName : null
  },

  tests :
  {

    encode,

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

  },

}

//

let Self = new wTestSuite( Proto )
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
