## Entities

### Backend( png.js, sharp, png-js, ... )
Module to choose from as low level parser of image data.

### Strategy ( one of the Class entity)
Chosen class to read image data.

### Namespace _.image 
Namespace for accessing data about image reader, writer and structure.

### Namespace _.image.reader
Namespace for accessing reader class of the image.

### Namespace _.image.rstructure
Namespace for accessing image structure.

### Namespace _.image.writer
Namespace for accessing image writer.

### Class _.image.reader.Reader
Class which represents a general image reader.

### Class _.image.reader.PngDotJs
Class which represents the PngDotJs image reader.

### Class _.image.reader.PngSharp
Class which represents the PngSharp image reader.

### Class _.image.reader.Pngjs
Class which represents the Pngjs image reader.

### Class _.image.reader.PngDashJs
Class which represents the PngDashJs image reader.

### Class _.image.reader.PngNodeLib
Class which represents the PngNodeLib image reader.

### Routine _.image.read
Routine to read image data.

### Routine _.image.readHead
Routine to read image data without pixels.

### Routine _.image.fileReadHead
Routine to read image file without pixel data.

### Routine _.image.fileRead
Routine to read image file.