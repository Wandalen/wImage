( function _Reader_s_( )
{

'use strict';

let _ = _global_.wTools;
let Self = _.image;

// --
// inter
// --

function fileRead( o )
{
  let self = this;
  let ready = new _.Consequence().take( null );

  if( _.strIs( arguments[ 0 ] ) )
  o = { filePath : o }
  o = _.routineOptions( fileRead, o );

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

fileRead.defaults =
{
  ... _.image.read.defaults,
  filePath : null,
}

// --
// declare
// --

let Extension =
{

  fileRead,

}

_.mapExtend( Self, Extension );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = _global_.wTools;

})();
