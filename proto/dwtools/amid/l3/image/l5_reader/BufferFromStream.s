let _ = _global_.wTools;

function bufferFromStream( o )
{
  let tempArray = [];
  let ready = new _.Consequence();

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.objectIs( o ) );
  _.assertMapHasOnly( o, bufferFromStream.defaults );
  _.assert( _.streamIs( o.src ), 'Expects stream as {-o.src-}' );

  o.src
  .on( 'data', ( chunk ) =>
  {
    tempArray.push( chunk )
  } );


  o.src
  .on( 'end', () =>
  {
    ready.take( BufferNode.from( tempArray ) )
  } );

  return ready;

}

bufferFromStream.defaults =
{
  src : null,
}

module.exports = bufferFromStream;

//

function bufferFromStream_( src )
{
  let tempArray = [];
  let ready = new _.Consequence();

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.streamIs( o.src ), 'Expects stream as {-o.src-}' );

  src
  .on( 'data', ( chunk ) =>
  {
    tempArray.push( chunk )
  } );


  src
  .on( 'end', () =>
  {
    ready.take( BufferNode.from( tempArray ) )
  } );

  return ready;

}
