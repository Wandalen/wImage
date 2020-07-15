## Entities
* Backend( png.js, sharp, png-js, ... ) - module to choose from as low level parser of image data.
* Strategy ( one of the Class entity) - chosen class to read image data.
* Namespaces:
  * _.image - for accessing data about image reader, writer and structure.
  * _.image.reader - for accessing reader class of the image.
  * _.image.rstructure - for accessing image structure.
  * _.image.writer - for accessing image writer.
* Classes:
  * _.image.reader.Reader - class which represents a general image reader.
  * _.image.reader.PngDotJs - class which represents the PngDotJs image reader.
  * _.image.reader.PngSharp - class which represents the PngSharp image reader.
  * _.image.reader.Pngjs - class which represents the Pngjs image reader.
  * _.image.reader.PngDashJs - class which represents the PngDashJs image reader.
  * _.image.reader.PngNodeLib - class which represents the PngNodeLib image reader..
* _.image.read - routine to read image data.
* _.image.readHead - routine to read image data without pixels.
* _.image.fileReadHead - routine to read image file without pixel data.
* _.image.fileRead - routine to read image file.