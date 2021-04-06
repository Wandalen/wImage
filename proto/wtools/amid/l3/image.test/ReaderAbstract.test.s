( function _ReaderAbstract_test_s_( )
{

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../../node_modules/Tools' );
  require( '../image/entry/Reader.s' );
  _.include( 'wTesting' );
}

const _ = _global_.wTools;

// --
// context
// --

function onSuiteBegin( test )
{
  let context = this;
  deleteDefault();
  _.image.reader[ context.readerName ].feature.default = 1;
  context.suiteTempPath = _.path.tempOpen( _.path.join( __dirname, '../..' ), 'ImageRead' );
  context.assetsOriginalPath = _.path.join( __dirname, '_asset' );

}

//

function onSuiteEnd( test )
{
  let context = this;
  _.image.reader[ context.readerName ].finit();
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
    var op = encoder.encode({ data, params });
    test.true( o.is( op.in.data ) );
    test.true( _.objectIs( op.params.originalStructure ) );

    var exp =
    {
      'in' :
      {
        'data' : op.in.data,
        'filePath' : null,
        'ext' : null,
        'format' : `buffer.${context.ext}`
      },
      'out' :
      {
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

    test.identical( op.in, exp.in );
    test.identical( op.out.format, exp.out.format );
    test.identical( op.params, exp.params );
    test.identical( op.sync, exp.sync );
    test.identical( op.error, exp.error );

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
          'ext' : context.ext,
          'format' : `buffer.${context.ext}`
        },
        'out' :
        {
          'format' : 'structure.image',
        },
        'params' :
        {
          onHead,
          'mode' : 'head',
          'headGot' : true,
          'originalStructure' : op.params.originalStructure,
        },
        'sync' : 0,
        'err' : null,
      }

      test.identical( op.in, exp.in );
      test.identical( op.out.format, exp.out.format );
      test.identical( op.params, exp.params );
      test.identical( op.sync, exp.sync );
      test.identical( op.error, exp.error );

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

      // test.true( _.streamIs( op.in.data ) );
      test.true( _.objectIs( op.params.originalStructure ) );

      var exp =
      {
        'in' :
        {
          'data' : op.in.data,
          'filePath' : null,
          'ext' : context.ext,
          'format' : `stream.${context.ext}`
        },
        'out' :
        {
          'format' : 'structure.image',
        },
        'params' :
        {
          onHead,
          'mode' : 'head',
          'headGot' : true,
          'originalStructure' : op.params.originalStructure,
        },
        'sync' : 0,
        'err' : null
      }

      test.identical( op.in, exp.in );
      test.identical( op.out.format, exp.out.format );
      test.identical( op.params, exp.params );
      test.identical( op.sync, exp.sync );
      test.identical( op.error, exp.error );

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
        'ext' : context.ext,
        'format' : `buffer.${context.ext}`
      },
      'out' :
      {
        'format' : 'structure.image',
      },
      'params' :
      {
        onHead,
        'mode' : 'head',
        'headGot' : true,
        'originalStructure' : op.params.originalStructure,
      },
      'sync' : 1,
      'err' : null
    }

    test.identical( op.in, exp.in );
    test.identical( op.out.format, exp.out.format );
    test.identical( op.params, exp.params );
    test.identical( op.sync, exp.sync );
    test.identical( op.error, exp.error );

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
        'ext' : context.ext,
        'format' : `stream.${context.ext}`
      },
      'out' :
      {
        'format' : 'structure.image',
      },
      'params' :
      {
        onHead,
        'mode' : 'head',
        'headGot' : true,
        'originalStructure' : op.params.originalStructure,
      },
      'sync' : 1,
      'err' : null,
    }

    test.identical( op.in, exp.in );
    test.identical( op.out.format, exp.out.format );
    test.identical( op.params, exp.params );
    test.identical( op.sync, exp.sync );
    test.identical( op.error, exp.error );

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
          'ext' : context.ext,
          'format' : `buffer.${context.ext}`
        },
        'out' :
        {
          'format' : 'structure.image',
        },
        'params' :
        {
          onHead,
          'mode' : 'full',
          'headGot' : true,
          'originalStructure' : op.params.originalStructure,
        },
        'sync' : 0,
        'err' : null
      }


      test.identical( op.in, exp.in );
      test.identical( op.out.format, exp.out.format );
      test.identical( op.params, exp.params );
      test.identical( op.sync, exp.sync );
      test.identical( op.error, exp.error );

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

      // test.true( _.streamIs( op.in.data ) );
      test.true( _.objectIs( op.params.originalStructure ) );

      var exp =
      {
        'in' :
        {
          'data' : op.in.data,
          'filePath' : null,
          'ext' : context.ext,
          'format' : `stream.${context.ext}`
        },
        'out' :
        {
          'format' : 'structure.image',
        },
        'params' :
        {
          onHead,
          'mode' : 'full',
          'headGot' : true,
          'originalStructure' : op.params.originalStructure,
        },
        'sync' : 0,
        'err' : null
      }


      test.identical( op.in, exp.in );
      test.identical( op.out.format, exp.out.format );
      test.identical( op.params, exp.params );
      test.identical( op.sync, exp.sync );
      test.identical( op.error, exp.error );

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

    var op = _.image.read({ data, ext : context.ext, sync : 1, onHead });

    test.description = 'operation';

    test.true( o.is( op.in.data ) );
    test.true( _.objectIs( op.params.originalStructure ) );

    var exp =
    {
      'in' :
      {
        'data' : op.in.data,
        'filePath' : null,
        'ext' : context.ext,
        'format' : `buffer.${context.ext}`
      },
      'out' :
      {
        'format' : 'structure.image',
      },
      'params' :
      {
        onHead,
        'mode' : 'full',
        'headGot' : true,
        'originalStructure' : op.params.originalStructure,
      },
      'sync' : 1,
      'err' : null
    }

    test.identical( op.in, exp.in );
    test.identical( op.out.format, exp.out.format );
    test.identical( op.params, exp.params );
    test.identical( op.sync, exp.sync );
    test.identical( op.error, exp.error );

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
        'ext' : context.ext,
        'format' : `stream.${context.ext}`
      },
      'out' :
      {
        'format' : 'structure.image',
      },
      'params' :
      {
        onHead,
        'mode' : 'full',
        'headGot' : true,
        'originalStructure' : op.params.originalStructure,
      },
      'sync' : 1,
      'err' : null,
    }

    test.identical( op.in, exp.in );
    test.identical( op.out.format, exp.out.format );
    test.identical( op.params, exp.params );
    test.identical( op.sync, exp.sync );
    test.identical( op.error, exp.error );

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

  // test.true( _.streamIs( op.in.data ) );
  test.true( _.objectIs( op.params.originalStructure ) );

  var exp =
  {
    'in' :
    {
      'data' : op.in.data,
      'filePath' : a.abs( `Pixels-2x2.${context.ext}` ),
      'ext' : context.ext,
      'format' : `stream.${context.ext}`
    },
    'out' :
    {
      'format' : 'structure.image',
    },
    'params' :
    {
      onHead,
      'mode' : 'head',
      'headGot' : true,
      'originalStructure' : op.params.originalStructure,
    },
    'sync' : 1,
    'err' : null,
  }

  test.identical( op.in, exp.in );
  test.identical( op.out.format, exp.out.format );
  test.identical( op.params, exp.params );
  test.identical( op.sync, exp.sync );
  test.identical( op.error, exp.error );

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

    // test.true( _.streamIs( op.in.data ) );
    test.true( _.objectIs( op.params.originalStructure ) );

    var exp =
    {
      'in' :
      {
        'data' : op.in.data,
        'filePath' : a.abs( `Pixels-2x2.${context.ext}` ),
        'ext' : context.ext,
        'format' : `stream.${context.ext}`
      },
      'out' :
      {
        'format' : 'structure.image',
      },
      'params' :
      {
        onHead,
        'mode' : 'head',
        'headGot' : true,
        'originalStructure' : op.params.originalStructure,
      },
      'sync' : 0,
      'err' : null,
    }

    test.identical( op.in, exp.in );
    test.identical( op.out.format, exp.out.format );
    test.identical( op.params, exp.params );
    test.identical( op.sync, exp.sync );
    test.identical( op.error, exp.error );

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
      'ext' : context.ext,
      'format' : `buffer.${context.ext}`
    },
    'out' :
    {
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

  test.identical( op.in, exp.in );
  test.identical( op.out.format, exp.out.format );
  test.identical( op.params, exp.params );
  test.identical( op.sync, exp.sync );
  test.identical( op.error, exp.error );

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
      'ext' : context.ext,
      'format' : `buffer.${context.ext}`
    },
    'out' :
    {
      'format' : 'structure.image',
    },
    'params' :
    {
      onHead,
      'mode' : 'full',
      'headGot' : true,
      'originalStructure' : op.params.originalStructure,
    },
    'sync' : 1,
    'err' : null,
  }

  test.identical( op.in, exp.in );
  test.identical( op.out.format, exp.out.format );
  test.identical( op.params, exp.params );
  test.identical( op.sync, exp.sync );
  test.identical( op.error, exp.error );

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
        'ext' : context.ext,
        'format' : `buffer.${context.ext}`,
      },
      'out' :
      {
        'format' : 'structure.image',
      },
      'params' :
      {
        onHead,
        'mode' : 'full',
        'headGot' : true,
        'originalStructure' : op.params.originalStructure,
      },
      'sync' : 0,
      'err' : null,
    }

    test.identical( op.in, exp.in );
    test.identical( op.out.format, exp.out.format );
    test.identical( op.params, exp.params );
    test.identical( op.sync, exp.sync );
    test.identical( op.error, exp.error );

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

//

function deleteDefault()
{
  _.image.reader[ 'Pngjs' ] ? _.image.reader[ 'Pngjs' ].feature.default = 0 : null;
  _.image.reader[ 'BmpDashJs' ] ? _.image.reader[ 'BmpDashJs' ].feature.default = 0 : null;
  _.image.reader[ 'JpegJs' ] ? _.image.reader[ 'JpegJs' ].feature.default = 0 : null;
  _.image.reader[ 'PngDashJs' ] ? _.image.reader[ 'PngDashJs' ].feature.default = 0 : null;
  _.image.reader[ 'PngDotJs' ] ? _.image.reader[ 'PngDotJs' ].feature.default = 0 : null;
  _.image.reader[ 'PngFast' ] ? _.image.reader[ 'PngFast' ].feature.default = 0 : null;
  _.image.reader[ 'PngNodeLib' ] ? _.image.reader[ 'PngNodeLib' ].feature.default = 0 : null;
  _.image.reader[ 'PngSharp' ] ? _.image.reader[ 'PngSharp' ].feature.default = 0 : null;
  _.image.reader[ 'UtifJs' ] ? _.image.reader[ 'UtifJs' ].feature.default = 0 : null;
}

// --
// declare
// --

const Proto =
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

const Self = wTestSuite( Proto )
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
