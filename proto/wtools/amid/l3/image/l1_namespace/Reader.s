( function _Reader_s_()
{

'use strict';

let _ = _global_.wTools;
let Self = _.image = _.image || Object.create( null );
_.image.reader = _.image.reader || Object.create( null );

// --
// inter
// --

function reader_pre( routine, args )
{
  let o = _.routineOptions( routine, args );
  _.assert( arguments.length === 2 );
  _.assert( _.longHas( [ 'full', 'head' ], o.mode ) );

  return o;
}

//

function read_body( o )
{

  let self = this;

  if( o.filePath && !o.ext )
  o.ext = _.path.ext( o.filePath ).toLowerCase();

  if( o.reader === null )
  {
    let o2 = _.mapOnly( o, self.readerDeduce.defaults );
    o2.single = 1;
    let selected = self.readerDeduce( o2 );
    _.mapExtend( o, selected );
    o.reader = new o.readerClass();
    //debugger;
  }

  let methodName = o.mode === 'full' ? 'read' : 'readHead';
  let o2 = _.mapOnly( o, o.reader[ methodName ].defaults );
  o2.onHead = handleHead;
  let result = o.reader[ methodName ]( o2 );
  //debugger;
  if( o.sync )
  return end( result );
  result.then( end );
  return result;

  /* */

  function handleHead( result )
  {
    for( let k in result )
    if( o[ k ] === undefined )
    o[ k ] = result[ k ];

    if( o.onHead )
    o.onHead( o );
  }

  function end( result )
  {
    for( let k in result )
    if( o[ k ] === undefined )
    o[ k ] = result[ k ];
    return o;
  }
}

read_body.defaults =
{
  reader : null,
  data : null,
  filePath : null,
  format : null,
  ext : null,
  sync : 1,
  mode : null,
  onHead : null,
}

//

let readHead = _.routineFromPreAndBody( reader_pre, read_body );
readHead.defaults.mode = 'head';

//

let read = _.routineFromPreAndBody( reader_pre, read_body );
read.defaults.mode = 'full';

//

function readerDeduce( o )
{
  let self = this;
  let result = [];
  debugger;

  o = _.routineOptions( readerDeduce, arguments );

  if( o.filePath && !o.ext )
  o.ext = _.path.ext( o.filePath ).toLowerCase();

  for( let n in _.image.reader )
  {
    // console.log( _.image.reader[ n ] )
    let Reader = _.image.reader[ n ];
    if( !Reader.Formats )
    continue;
    let supports = Reader.Supports( _.mapBut( o, [ 'single' ] ) );
    supports.score = calculateScore( _.image.reader[ n ] )
    if( supports )
    result.push( supports );
  }

  result.sort( ( a, b ) =>
  {
    if( b.score - a.score > 0 )
    {
      return 1;
    }
    else if( b.score - a.score === 0 )
    {
      if( b.MethodsNativeCount > a.MethodsNativeCount )
      return 1
      else
      return 0
    }
    else
    {
      return -1;
    }
  });

  // console.log( 'RESULTS_ARRAY: ', result );
  // result = result.slice( 0, 1 );
  // console.log( 'RESULTS_ARRAY 1 ELEM: ', result );

  if( o.single )
  {
    /*
    result = result.slice( 0, 1 );
    _.assert
    (
      result.length >= 1,
      () => `Found no reader for format:${o.format} ext:${o.ext} filePath:${o.filePath}.`
    );
    _.assert
    (
      result.length <= 1,
      () => `Found ${result.length} readers for format:${o.format} ext:${o.ext} filePath:${o.filePath}, but need only one.`
    );
    */
    return result[ 0 ]
  }

  return result;
}

readerDeduce.defaults =
{
  data : null,
  format : null,
  filePath : null,
  ext : null,
  single : 1,
}

//

function calculateScore( reader )
{
  let self = this;
  let score = 0;

  if( reader.LimitationsRead )
  return 0;
  if( reader.SupportsDimensions )
  score += 20;
  if( reader.SupportsBuffer )
  score += 20;
  if( reader.SupportsDepth )
  score += 5;
  if( reader.SupportsColor )
  score += 5;
  if( reader.SupportsSpecial )
  score += 2;

  return score;

}

// --
// declare
// --

let Extension =
{

  readHead,
  read,
  readerDeduce,

}

_.mapExtend( Self, Extension );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = _global_.wTools;

})();
