( function _Reader_s_()
{

'use strict';

let _ = _global_.wTools;
let Self = _.image;

// --
// inter
// --

function fileRead_head( routine, args )
{
  let o = args[ 0 ]
  if( _.strIs( args[ 0 ] ) )
  o = { filePath : o }
  o = _.routineOptions( routine, o );
  _.assert( args.length === 1 );
  _.assert( arguments.length === 2 );

  return o;
}

//

function fileReadHead_body( o )
{
  let self = this;
  let ready = new _.Consequence().take( null );
  let data;
  o = _.assertRoutineOptions( fileReadHead_body, arguments );
  // if( o.withStream === null )
  // {
  /*
    Find a class that will create a strategy
    o.withStream = !!o.reader.SupportsStream;
  */
  //   o.withStream = true;
  // }
  // or fileRead
  // if( o.withStream === true )
  // {
  data = _.fileProvider.streamRead
  ({
    filePath : o.filePath,
    encoding : 'buffer.raw',
  });
  // }
  // else
  // {
  //   data = _.fileProvider.fileRead
  //   ({
  //     filePath : o.filePath,
  //   });
  // }

  o.data = data;

  ready.then( () => self.readHead( o ) );

  if( o.sync )
  return ready.sync();
  return ready;
}

fileReadHead_body.defaults =
{
  ... _.image.readHead.defaults,
  filePath : null,
  // withStream : null,
}

_.assert( _.image.readHead.defaults.methodName === undefined );
_.assert( _.image.readHead.defaults.sync !== undefined );

let fileReadHead = _.routine.uniteCloning_( fileRead_head, fileReadHead_body );

//

function fileRead_body( o )
{
  let self = this;
  let ready = new _.Consequence().take( null );

  o = _.assertRoutineOptions( fileRead_body, arguments );

  ready
  .then( () =>
  {
    return _.fileProvider.fileRead
    ({
      filePath : o.filePath,
      sync : o.sync,
      encoding : 'buffer.raw',
    });
  })
  .then( ( data ) =>
  {
    o.data = data;
    return self.read( o );
  });

  if( o.sync )
  return ready.sync();
  return ready;
}

fileRead_body.defaults =
{
  ... _.image.read.defaults,
  filePath : null,
}

_.assert( _.image.read.defaults.methodName === undefined );
_.assert( _.image.read.defaults.sync !== undefined );

//

let fileRead = _.routine.uniteCloning_( fileRead_head, fileRead_body );

// --
// declare
// --

let Extension =
{

  fileReadHead,
  fileRead,

}

_.mapExtend( Self, Extension );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = _global_.wTools;

} )();
