( function _Reader_s_( )
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

  return o;
}

//

function read_body( o )
{
  let self = this;

  if( o.filePath && !o.ext )
  o.ext = _.path.ext( o.filePath );

  if( o.reader === null )
  {
    let o2 = _.mapOnly( o, self.readerSelect.defaults );
    o2.single = 1;
    let selected = self.readerSelect( o2 );
    _.mapExtend( o, selected );
    o.reader = new o.readerClass();
  }

  let o2 = _.mapOnly( o, o.reader[ o.methodName ].defaults );
  let result = o.reader[ o.methodName ]( o2 )

  if( o.sync )
  return end( result );
  result.then( end );
  return result;

  function end( result )
  {
    return _.mapExtend( o, result );
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
  methodName : null,
}

//

let readHead = _.routineFromPreAndBody( reader_pre, read_body );
readHead.defaults.methodName = 'readHead';

//

let read = _.routineFromPreAndBody( reader_pre, read_body );
read.defaults.methodName = 'read';

// //
//
// function readHead( o )
// {
//   let self = this;
//
//   o = _.routineOptions( read, arguments );
//
//   if( o.filePath && !o.ext )
//   o.ext = _.path.ext( o.filePath );
//
//   if( o.reader === null )
//   {
//     let o2 = _.mapOnly( o, self.readerSelect.defaults );
//     o2.single = 1;
//     let selected = self.readerSelect( o2 );
//     _.mapExtend( o, selected );
//     o.reader = new o.readerClass();
//   }
//
//   let o2 = _.mapOnly( o, o.reader.readHead.defaults );
//
//   let result = o.reader.readHead( o2 )
//
//   if( o.sync )
//   return end( result );
//
//   result.then( end );
//
//   return result;
//
//   // function end( result )
//   // {
//   //   return _.mapExtend( o, result );
//   // }
// }
//
// readHead.defaults =
// {
//   reader : null,
//   data : null,
//   filePath : null,
//   format : null,
//   ext : null,
//   sync : 1,
// }
//
// //
//
// function read( o )
// {
//   let self = this;
//
//   o = _.routineOptions( read, arguments );
//
//   if( o.filePath && !o.ext )
//   o.ext = _.path.ext( o.filePath );
//
//   if( o.reader === null )
//   {
//     let o2 = _.mapOnly( o, self.readerSelect.defaults );
//     o2.single = 1;
//     let selected = self.readerSelect( o2 );
//     _.mapExtend( o, selected );
//     o.reader = new o.readerClass();
//   }
//
//   let o2 = _.mapOnly( o, o.reader.read.defaults );
//   let result = o.reader.read( o2 )
//
//   if( o.sync )
//   return result;
//
//   result.then( end );
//
//   return result;
//
//   function end( result )
//   {
//     return _.mapExtend( o, result );
//   }
// }
//
// read.defaults =
// {
//   ... readHead.defaults,
// }

//

function readerSelect( o )
{
  let self = this;
  let result = [];

  o = _.routineOptions( readerSelect, arguments );

  if( o.filePath && !o.ext )
  o.ext = _.path.ext( o.filePath );

  for( let n in _.image.reader )
  {
    let Reader = _.image.reader[ n ];
    if( !Reader.Formats )
    continue;
    let supports = Reader.Supports( _.mapBut( o, [ 'single' ] ) );
    if( supports )
    result.push( supports );
  }

  if( o.single )
  {
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
    return result[ 0 ]
  }

  return result;
}

readerSelect.defaults =
{
  data : null,
  format : null,
  filePath : null,
  ext : null,
  single : 1,
}

// --
// declare
// --

let Extension =
{

  readHead,
  read,
  readerSelect,

}

_.mapExtend( Self, Extension );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = _global_.wTools;

})();
