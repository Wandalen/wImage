( function _ReaderPngDash_test_s_( )
{

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../../wtools/Tools.s' );
  require( '../image/entry/ReaderPngDashJs.s' );
  require( './ReaderAbstract.test.s' );
}

let _ = _global_.wTools;
let Parent = _global_.wTests.ImageReadAbstract;

// --
// context
// --

// --
// tests
// --


function encode_( test )
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

    test.description = 'operation';

    var params = {}
    var encoder = _.gdf.selectSingleContext({ ext : context.ext })
    var op = encoder.encode({ data, params });

    var exp =
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
    }

    test.identical( op.out.data, exp.data );

  }

  /* */

}

//

function readHeadBufferAsync_( test )
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
      var op = _.image.readHead({ data, ext : context.ext, sync : 0, onHead });
      return op;
    })

    a.ready.then( ( op ) =>
    {
      test.description = 'operation';

      var exp =
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
      }
      test.identical( op.out.data, exp.data );

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

function readHeadStreamAsync_( test )
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
      var op = _.image.readHead({ data, ext : context.ext, sync : 0, onHead });
      return op;
    })

    a.ready.then( ( op ) =>
    {

      test.description = 'operation';
      test.is( _.bufferNodeIs( op.in.data ) );

      var exp =
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
      }

      test.identical( op.out.data, exp.data );

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


function readHeadBufferSync_( test )
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
    var op = _.image.readHead({ data, ext : context.ext, sync : 1, onHead });

    test.description = 'operation';

    var exp =
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
    }

    test.identical( op.out.data, exp.data );

  }

  /* */

  function onHead( op )
  {
    callbacks.push( op );
  }

}

//

function readHeadStreamSync_( test )
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
    var op = _.image.readHead({ data, ext : context.ext, sync : 1, onHead });

    test.description = 'operation';

    var exp =
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
    }

    test.identical( op.out.data, exp.data );

  }

  /* */

  function onHead( op )
  {
    callbacks.push( op );
  }

}

//

function readBufferAsync_( test )
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
      var op = _.image.read({ data, ext : context.ext, sync : 0, onHead });
      return op;
    })

    a.ready.then( ( op ) =>
    {
      test.description = 'operation';

      var exp =
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
      }

      test.identical( op.out.data, exp.data );

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

function readStreamAsync_( test )
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
      var op = _.image.read({ data, ext : context.ext, sync : 0, onHead });
      return op;
    })

    a.ready.then( ( op ) =>
    {
      test.description = 'operation';

      test.is( _.bufferNodeIs( op.in.data ) );
      var exp =
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
      }

      test.identical( op.out.data, exp.data );

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

function readBufferSync_( test )
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

    var op = _.image.read({ data, ext : context.ext, sync : 1, onHead });

    test.description = 'operation';

    var exp =
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
      }
    }

    test.identical( op.out.data, exp.data );

  }

  /* */

  function onHead( op )
  {
    callbacks.push( op );
  }

}

//

function readStreamSync_( test )
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
    var op = _.image.read({ data, ext : context.ext, sync : 1, onHead });

    test.description = 'operation';

    test.is( _.streamIs( data ) );

    var exp =
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
    }

    test.identical( op.out.data, exp.data );

  }

  /* */

  function onHead( op )
  {
    callbacks.push( op );
  }

}

//

function fileReadHeadSync_( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  let callbacks = [];

  /* */

  test.case = 'basic';

  a.reflect();
  var op = _.image.fileReadHead({ filePath : a.abs( `Pixels-2x2.${context.ext}` ), sync : 1, onHead });

  test.description = 'operation';

  test.is( _.bufferNodeIs( op.in.data ) );

  var exp =
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
  }

  test.identical( op.out.data, exp.data );

  /* */

  function onHead( op )
  {
    callbacks.push( op );
  }

}

//

function fileReadHeadAsync_( test )
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
    return op;
  })

  a.ready.then( ( op ) =>
  {
    test.description = 'operation';

    test.is( _.bufferNodeIs( op.in.data ) );

    var exp =
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
      }
    }

    test.identical( op.out.data, exp.data );

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

function fileReadSync_( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  let callbacks = [];

  /* */

  test.case = 'single path';

  a.reflect();

  var op = _.image.fileRead( a.abs( `Pixels-2x2.${context.ext}` ) );

  test.description = 'operation';

  var exp =
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
  }

  test.identical( op.out.data, exp.data );

  /* */

  test.case = 'options map';

  a.reflect();
  callbacks = [];

  var op = _.image.fileRead({ filePath : a.abs( `Pixels-2x2.${context.ext}` ), sync : 1, onHead });

  test.description = 'operation';

  var exp =
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
  }

  test.identical( op.out.data, exp.data );

  /* */

  function onHead( op )
  {
    callbacks.push( op );
  }

}

//

function fileReadAsync_( test )
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

    return op;
  })

  a.ready.then( ( op ) =>
  {

    test.description = 'operation';

    var exp =
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
      }
    }

    test.identical( op.out.data, exp.data );

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
    encode_,
    readHeadBufferAsync_,
    readHeadStreamAsync_,
    readHeadBufferSync_,
    readHeadStreamSync_,

    readBufferAsync_,
    readStreamAsync_,
    readBufferSync_,
    readStreamSync_,

    fileReadHeadSync_,
    fileReadHeadAsync_,
    fileReadSync_,
    fileReadAsync_,
  },

}

//

var Self = new wTestSuite( Proto ).inherit( Parent );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
