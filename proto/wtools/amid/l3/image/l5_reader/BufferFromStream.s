let _ = _global_.wTools;

function bufferFromStream( o )
{
  let chunks = [];
  let ready = new _.Consequence();

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.objectIs( o ) );
  _.assertMapHasOnly( o, bufferFromStream.defaults );
  _.assert( _.streamIs( o.src ), 'Expects stream as {-o.src-}' );

  o.src
  .on( 'data', ( chunk ) =>
  {
    chunks.push( chunk )
  } );

  o.src
  .on( 'end', () =>
  {
    try
    {
      ready.take( Buffer.concat( chunks ) )
    }
    catch( err )
    {
      console.log( err )
    }
  } );

  return ready;
}

bufferFromStream.defaults =
{
  src : null,
}

module.exports = bufferFromStream;
