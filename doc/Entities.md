## Entities
1. Backend( png.js, sharp, png-js, ... ) - entity to choose from as low level parser of image data.
2. Strategy ( one of the Class entity) - chosen parser to read image data.
3. Namespace ( _.image, _.image.reader, _.image.rstructure,  _.image.writer ) - a map with fields and routines.
4. Class (  _.image.reader.Reader,  _.image.reader.PngDotJs, _.image.reader.PngSharp,  _.image.reader.Pngjs, _.image.reader.PngDashJs, _.image.reader.PngNodeLib ) - class which represents an image reader.
5. _.image.read - routine to read image data.
6. _.image.readHead - routine to read image data without pixels.
7. _.image.fileReadHead - routine to read image file without pixel data.
8. _.image.fileRead - routine to read image file.