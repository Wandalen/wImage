let _ = _global_.wTools;

async function bufferFromStream( o )
{
  let chunks = [];
  let ready = new _.Consequence();

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.objectIs( o ) );
  _.assertMapHasOnly( o, bufferFromStream.defaults );
  _.assert( _.streamIs( o.src ), 'Expects stream as {-o.src-}' );

  // o.src
  // .on( 'data', ( chunk ) =>
  // {
  //   chunks.push( chunk )
  // } );


  // o.src
  // .on( 'end', () =>
  // {
  //   try
  //   {
  //     ready.take( Buffer.concat( chunks ) )
  //     return ready
  //   }
  //   catch( err )
  //   {
  //     console.log( err )
  //   }
  // } );
  try
  {
    debugger
    for await( const chunk of o.src )
    {
      debugger
      chunks.push( chunk );
      debugger
    }

    debugger
    ready.take( Buffer.concat( chunks ) );
    debugger
    // console.log( ready.argumentsGet() )
    return ready;
  }
  catch( err )
  {
    console.log( 'Error: ', err );
  }
}

bufferFromStream.defaults =
{
  src : null,
}

module.exports = bufferFromStream;
