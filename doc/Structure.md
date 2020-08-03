## Examples of data available through modules:

#### **pngjs**
```javascript
{
  width : 2,
  height : 2,
  depth : 8,
  interlace : false,
  palette : false,
  color : true,
  alpha : true,
  bpp : 4,
  colorType : 6,
  data : <Buffer ff 00 00 ff 00 ff 00 ff 00 00 ff ff ff ff ff ff>,
  gamma : 0.45455
}
```

#### **png-js**
```javascript
{
  data : <Buffer 89 50 4e 47 0d 0a 1a 0a 00 00 00 0d 49 48 44 52 00 00 00 02 00 00 00 02 08 06 00 00 00 72 b6 0d 24 00 00 00 01 73 52 47 42 00 ae ce 1c e9 00 00 00 04 ... 77 more bytes>,
  pos : 123,
  palette : [],
  imgData : <Buffer 18 57 63 f8 cf 00 44 40 c8 08 a4 81 80 81 01 00 46 d4 07 fa>,
  transparency : {},
  text : {},
  width : 2,
  height : 2,
  bits : 8,
  colorType : 6,
  compressionMethod : 0,
  filterMethod : 0,
  interlaceMethod : 0,
  colors : 3,
  hasAlphaChannel : true,
  pixelBitlength : 32,
  colorSpace : 'DeviceRGB',
  buffer : <Buffer ff 00 00 ff 00 ff 00 ff 00 00 ff ff ff ff ff ff>
}
```

#### **png.js**
```javascript
{
	width : 2,
	height : 2,
	bitDepth : 8,
	colorType : 6,
	compressionMethod : 0,
	filterMethod : 0,
	interlaceMethod : 0,
	colors : 4,
	alpha : true,
	pixelBits : 0,
	palette : null,
	pixels : <Buffer ff 00 00 ff 00 ff 00 ff 00 00 ff ff ff ff ff ff>
}
```
*Unable to parse some sorts of interlaced images (for example with Adam7 Interlacing )*

#### **node-libpng**
```javascript
{
  bitDepth : 8,
  channels : 4,
  colorType : 'rgba',
  height : 2,
  width : 2,
  interlaceType : 'none',
  rowBytes : 8,
  offsetX : 0,
  offsetY : 0,
  pixelsPerMeterX : 3778,
  pixelsPerMeterY : 3778,
  data : <Buffer ff 00 00 ff 00 ff 00 ff 00 00 ff ff ff ff ff ff>,
  palette : undefined,
  gamma : 0.45455,
  time : undefined,
  backgroundColor : undefined
}
```

#### **sharp**
```javascript
{
  metadata : {
    format : 'png',
    size : 127,
    width : 2,
    height : 2,
    space : 'srgb',
    channels : 4,
    depth : 'uchar',
    density : 96,
    isProgressive : false,
    hasProfile : false,
    hasAlpha : true
  },
  buffer : <Buffer ff 00 00 ff 00 ff 00 ff 00 00 ff ff ff ff ff ff>
}
```
*No information about bit depth of an image*

#### **bmp-js**
```javascript
{
  pos : 70,
  buffer : <Buffer 42 4d 48 00 00 00 00 00 00 00 36 00 00 00 28 00 00 00 02 00 00 00 02 00 00 00 01 00 20 00 00 00 00 00 12 00 00 00 23 2e 00 00 23 2e 00 00 00 00 00 00 ... 22 more bytes>,
  is_with_alpha : false,
  bottom_up : true,
  flag : 'BM',
  fileSize : 72,
  reserved : 0,
  offset : 54,
  headerSize : 40,
  width : 2,
  height : 2,
  planes : 1,
  bitPP : 32,
  compress : 0,
  rawSize : 18,
  hr : 11811,
  vr : 11811,
  colors : 0,
  importantColors : 0,
  data : <Buffer 00 00 00 ff 00 00 ff 00 00 ff 00 00 00 ff ff ff>
}
```
*No information about color channels in image*

#### **utif**
```javascript
{
  t254 : [ 0 ],
  t256 : [ 2 ],
  t257 : [ 2 ],
  t258 : [ 8, 8, 8 ],
  t259 : [ 1 ],
  t262 : [ 2 ],
  t273 : [ 28680 ],
  t274 : [ 1 ],
  t277 : [ 3 ],
  t278 : [ 2 ],
  t279 : [ 12 ],
  t282 : [ 300 ],
  t283 : [ 300 ],
  t284 : [ 1 ],
  t296 : [ 2 ],
  t305 : [ 'Adobe Photoshop CC 2018 (Windows)' ],
  t306 : [ '2020:06:02 16:37:22' ],
  t700 : Uint8Array(22418) [
     60,  63, 120, 112,  97,  99, 107, 101, 116,  32,  98, 101,
    103, 105, 110,  61,  34, 239, 187, 191,  34,  32, 105, 100,
     61,  34,  87,  53,  77,  48,  77, 112,  67, 101, 104, 105,
     72, 122, 114, 101,  83, 122,  78,  84,  99, 122, 107,  99,
     57, 100,  34,  63,  62,  10,  60, 120,  58, 120, 109, 112,
    109, 101, 116,  97,  32, 120, 109, 108, 110, 115,  58, 120,
     61,  34,  97, 100, 111,  98, 101,  58, 110, 115,  58, 109,
    101, 116,  97,  47,  34,  32, 120,  58, 120, 109, 112, 116,
    107,  61,  34,  65,
    ... 22318 more items
  ],
  t34377 : Uint8Array(2776) [
     56,  66,  73,  77,   4,  37,   0,   0,   0,   0,   0, 16,
      0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,  0,
      0,   0,   0,   0,  56,  66,  73,  77,   4,  58,   0,  0,
      0,   0,   0, 229,   0,   0,   0,  16,   0,   0,   0,  1,
      0,   0,   0,   0,   0,  11, 112, 114, 105, 110, 116, 79,
    117, 116, 112, 117, 116,   0,   0,   0,   5,   0,   0,  0,
      0,  80, 115, 116,  83,  98, 111, 111, 108,   1,   0,  0,
      0,   0,  73, 110, 116, 101, 101, 110, 117, 109,   0,  0,
      0,   0,  73, 110,
    ... 2676 more items
  ],
  t34665 : [ 28692 ],
  exifIFD : { t40961: [ 1 ], t40962: [ 2 ], t40963: [ 2 ] },
  t34675 : Uint8Array(3144) [
      0,   0,  12,  72,  76, 105, 110, 111,  2, 16,   0,   0,
    109, 110, 116, 114,  82,  71,  66,  32, 88, 89,  90,  32,
      7, 206,   0,   2,   0,   9,   0,   6,  0, 49,   0,   0,
     97,  99, 115, 112,  77,  83,  70,  84,  0,  0,   0,   0,
     73,  69,  67,  32, 115,  82,  71,  66,  0,  0,   0,   0,
      0,   0,   0,   0,   0,   0,   0,   1,  0,  0, 246, 214,
      0,   1,   0,   0,   0,   0, 211,  45, 72, 80,  32,  32,
      0,   0,   0,   0,   0,   0,   0,   0,  0,  0,   0,   0,
      0,   0,   0,   0,
    ... 3044 more items
  ],
  isLE : true,
  width : 2,
  height : 2,
  data : Uint8Array(12) [
    255,   0, 0,   0, 255,
      0,   0, 0, 255, 255,
    255, 255
  ]
}
```

#### **omggif**
```javascript
{
  metadata : {
    x : 0,
    y : 0,
    width : 2,
    height : 2,
    has_local_palette : false,
    palette_offset : 13,
    palette_size : 256,
    data_offset : 799,
    data_length : 10,
    transparent_index : 252,
    interlaced : false,
    delay : 0,
    disposal : 0
  },
  buffer : <Buffer 08 07 00 a5 91 28 b0 2f 20 00>
}
```

#### **jpeg-js**
```javascript
{
  width : 2,
  height : 2,
  exifBuffer : undefined,
  data : <Buffer f9 00 00 ff 00 ff 00 ff 09 04 ff ff ff f9 ff ff>
}
```
