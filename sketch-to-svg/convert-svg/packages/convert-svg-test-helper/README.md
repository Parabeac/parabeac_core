# convert-svg-test-helper

A [Node.js](https://nodejs.org) package for testing SVG converters implementing using
[convert-svg-core](https://github.com/neocotic/convert-svg/tree/master/packages/convert-svg-core).

[![Build Status](https://img.shields.io/travis/neocotic/convert-svg/develop.svg?style=flat-square)](https://travis-ci.org/neocotic/convert-svg)
[![License](https://img.shields.io/github/license/neocotic/convert-svg.svg?style=flat-square)](https://github.com/neocotic/convert-svg/blob/master/LICENSE.md)
[![Release](https://img.shields.io/github/release/neocotic/convert-svg.svg?style=flat-square)](https://github.com/neocotic/convert-svg/tree/master/packages/convert-svg-test-helper)

* [Install](#install)
* [Usage](#usage)
* [Bugs](#bugs)
* [Contributors](#contributors)
* [License](#license)

## Install

Install using [npm](https://www.npmjs.com):

``` bash
$ npm install --save-dev convert-svg-test-helper
```

You'll need to have at least [Node.js](https://nodejs.org) 8 or newer.

If you're looking to create a converter for a new format, we'd urge you to consider contributing to this framework so
that it can be easily integrated and maintained. Read the [Contributors](#contributors) section for information on how
you can contribute.

## Usage

Take a look at the tests for existing SVG converters under the
[packages](https://github.com/neocotic/convert-svg/tree/master/packages) directory for examples on how to use this
package.

## Testing

Testing your SVG converter actually works is just as important as implementing it. Since `convert-svg-core` contains a
lot of the conversion logic, a
[convert-svg-test-helper](https://github.com/neocotic/convert-svg/packages/convert-svg-test-helper) package is available
to make testing implementations even easier. Again, take a look at the tests for existing SVG converters under the
[packages](https://github.com/neocotic/convert-svg/tree/master/packages) directory for examples.

## Bugs

If you have any problems with this package or would like to see changes currently in development you can do so
[here](https://github.com/neocotic/convert-svg/issues).

## Contributors

If you want to contribute, you're a legend! Information on how you can do so can be found in
[CONTRIBUTING.md](https://github.com/neocotic/convert-svg/blob/master/CONTRIBUTING.md). We want your suggestions and
pull requests!

A list of all contributors can be found in [AUTHORS.md](https://github.com/neocotic/convert-svg/blob/master/AUTHORS.md).

## License

Copyright © 2018 Alasdair Mercer

See [LICENSE.md](https://github.com/neocotic/convert-svg/raw/master/LICENSE.md) for more information on our MIT license.
