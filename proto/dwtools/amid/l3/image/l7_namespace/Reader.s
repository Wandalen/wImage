/*eslint-disable*/
( function _Reader_s_()
{

'use strict';

let _ = _global_.wTools;
let Self = _.image;

// --
// inter
// --

function fileRead_pre( routine, args )
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

  o = _.assertRoutineOptions( fileReadHead_body, arguments );

  let stream = _.fileProvider.streamRead
  ({
    filePath : o.filePath,
    encoding : 'buffer.raw',
  });

  if( self.SupportsStream )
  o.data = stream;
  else
  {
    let data = bufferFromStream( { src : stream } );
    data.then( ( data ) => o.data = data )
  }

  ready.then( () => self.readHead( o ) );

  if( o.sync )
  return ready.sync();
  return ready;
}

fileReadHead_body.defaults =
{
  ... _.image.readHead.defaults,
  filePath : null,
}

_.assert( _.image.readHead.defaults.methodName === undefined );
_.assert( _.image.readHead.defaults.sync !== undefined );

let fileReadHead = _.routineFromPreAndBody( fileRead_pre, fileReadHead_body );

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

function bufferFromStream( o )
{
  // let result;
  let tempArray = [];
  let ready = new _.Consequence();
  debugger;
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.objectIs( o ) );
  _.assertMapHasOnly( o, bufferFromStream.defaults );
  _.assert( _.streamIs( o.src ), 'Expects stream as {-o.src-}' );
  debugger;
  o.src
  .on( 'data', ( chunk ) =>
  {
    debugger;
    // console.log( chunk )
    tempArray.push( chunk )
    debugger;
  } );
  console.log( tempArray )
  debugger;
  o.src
  .on( 'end', () =>
  {
    ready.take( BufferNode.from( tempArray ) )
  } );
  debugger;
  console.log( ready )
  return ready;

}

bufferFromStream.defaults =
{
  src : null,
}

//

let fileRead = _.routineFromPreAndBody( fileRead_pre, fileRead_body );

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
