# convert-svg

[![Build Status](https://img.shields.io/travis/neocotic/convert-svg/develop.svg?style=flat-square)](https://travis-ci.org/neocotic/convert-svg)
[![License](https://img.shields.io/github/license/neocotic/convert-svg.svg?style=flat-square)](https://github.com/neocotic/convert-svg/blob/master/LICENSE.md)
[![Release](https://img.shields.io/github/release/neocotic/convert-svg.svg?style=flat-square)](https://github.com/neocotic/convert-svg)

This monorepo contains the following [Node.js](https://nodejs.org) packages that can convert a SVG into another format
using headless Chromium:

* [convert-svg-core](https://github.com/neocotic/convert-svg/tree/master/packages/convert-svg-core)
* [convert-svg-test-helper](https://github.com/neocotic/convert-svg/tree/master/packages/convert-svg-test-helper)
* [convert-svg-to-jpeg](https://github.com/neocotic/convert-svg/tree/master/packages/convert-svg-to-jpeg)
* [convert-svg-to-png](https://github.com/neocotic/convert-svg/tree/master/packages/convert-svg-to-png)

The first two packages are core dependencies for SVG converters, which make up the remainder of the packages, trying to
adhere to the following naming convention:

    convert-svg-to-<FORMAT>

It works by using headless Chromium to take a screenshot of the SVG and outputs the buffer. This does mean that the
supported output formats is limited to those supported by that the API for headless Chromium, however, as more formats
are added, additional packages can easily be created.

Each of the SVG converters will share a common API and CLI with the same options, however, some converters may come with
additional options specific for their output format.

Click on the links above for the SVG converters for more information on how to install, use, and even contribute to
them. 

## License

Copyright © 2018 Alasdair Mercer

See [LICENSE.md](https://github.com/neocotic/convert-svg/raw/master/LICENSE.md) for more information on our MIT license.
