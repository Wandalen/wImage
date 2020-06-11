
let _ = require( 'wimage' );

/**/

let image = _.image.fileRead( __dirname + '/../proto/dwtools/amid/l3/image.test/_assets/basic/Pixels-2x2.png' ).structure;
console.log( image );
