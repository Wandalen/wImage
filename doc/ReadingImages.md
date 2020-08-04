### Reading images

| **N** | **BSF** | **BAF** | **SSF** | **SAF** | **BSH** | **BAH** | **SSH** | **SAH** | **Lims** |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| [**sharp**](https://github.com/lovell/sharp) | **X** | **no** | **X** | **X** | **X** | **-** | **X** | **X** | unable to get bit depth |
| [**jpeg-js**](https://github.com/eugeneware/jpeg-js) | **yes** | **yes+** | **yes+** | **yes+** | **yes+** | **yes+** | **yes+** | **yes+** | unable to get color data |
| [**pngjs**](https://github.com/lukeapage/pngjs) | **yes** | **yes** | **yes** | **yes** | **yes+** | **yes+** | **yes+** | **yes+** | - |
| [**node-libpng**](https://github.com/Prior99/node-libpng) | **yes** | **yes+** | **yes+** | **yes+** | **X** | **X** | **X** | **X** | - |
| [**bmp-js**](https://github.com/shaozilee/bmp-js) | **yes** | **yes+** | **yes+** | **yes+** | **yes+** | **yes+** | **yes+** | **yes+** | unable to get color data |
| [**omggif**](https://github.com/deanm/omggif) | **yes** | **yes+** | **yes+** | **yes+** | **yes+** | **yes+** | **yes+** | **yes+** | unable to get buffer, bit depth, color data |
| [**utif**](https://github.com/photopea/UTIF.js) | **yes** | **yes+** | **yes+** | **yes+** | **yes** | **yes+** | **yes+** | **yes+** | - |
| [**png.js**](https://github.com/arian/pngjs) | **yes+** | **yes** | **yes+** | **yes+** | **yes+** | **yes** | **yes+** | **yes+** | unable to read 1 bit img, img with some kinds of interlacing  |
| [**png-js**](https://github.com/foliojs/png.js) | **yes+** | **yes** | **yes+** | **yes+** | **yes** | **yes+** | **yes+** | **yes+** | unable to read images with some kinds of filter algorithms |
| [**fast-png**](https://github.com/image-js/fast-png) | **+** | **yes+** | **yes+** | **yes+** | **yes** | **yes+** | **yes+** | **yes+** | unable to read images with some kinds of filter algorithms, unable to read interlacing |

**Description:**
* **BSF** - Buffer Sync Full.
* **BAF** - Buffer Async Full.
* **SSF** - Stream Sync Full.
* **SAF** - Stream Async Full.
* **BSH** - Buffer Sync Head.
* **BAH** - Buffer Async Head.
* **SSH** - Stream Sync Head.
* **SAH** - Stream Async Head.
* **yes** - Implemented.
* **no** - Not implemented.
* **X** - Not supported.
* **yes+** - Not Supported, but implemented.
* **-** - No info yet.
* **Lims** - Limitations of the module. '-' - no limitations.