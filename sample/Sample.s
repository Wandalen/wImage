
let _ = require( 'wimage' );

/**/

let image = _.image.fileReadHead( __dirname + '/../proto/wtools/amid/l3/image.test/_assets/basic/Pixels-2x2.jpg' ).structure;
console.log( image );
