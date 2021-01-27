
let _ = require( 'wimage' );

/**/

let image = _.image.fileReadHead( __dirname + '/Pixels-2x2.png' ).out;
console.log( image );

/*
log :
[Object: null prototype] {
  data:
   [Object: null prototype] {
     special: [Object: null prototype] { interlaced: false },
     channelsMap: [Object: null prototype] {},
     channelsArray: [ 'red', 'green', 'blue', 'alpha' ],
     buffer: null,
     dims: [ 2, 2 ],
     bytesPerPixel: 1,
     bitsPerPixel: 8,
     hasPalette: false },
  format: 'structure.image' }
*/
