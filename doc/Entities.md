## Entities
* Backend( png.js, sharp, png-js, ... ) - module to choose from as low level parser of image data.
* Strategy ( one of the Class entity) - chosen class to read image data.
* Namespace _.image - for accessing data about image reader, writer and structure.
* Namespace _.image.reader - for accessing reader class of the image.
* Namespace _.image.rstructure - for accessing image structure.
* Namespace _.image.writer - for accessing image writer.
* Class _.image.reader.Reader - class which represents a general image reader.
* Class _.image.reader.PngDotJs - class which represents the PngDotJs image reader.
* Class _.image.reader.PngSharp - class which represents the PngSharp image reader.
* Class _.image.reader.Pngjs - class which represents the Pngjs image reader.
* Class _.image.reader.PngDashJs - class which represents the PngDashJs image reader.
* Class _.image.reader.PngNodeLib - class which represents the PngNodeLib image reader..
* _.image.read - routine to read image data.
* _.image.readHead - routine to read image data without pixels.
* _.image.fileReadHead - routine to read image file without pixel data.
* _.image.fileRead - routine to read image file.