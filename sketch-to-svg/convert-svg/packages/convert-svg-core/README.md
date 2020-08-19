# convert-svg-core

The core [Node.js](https://nodejs.org) package for converting SVG into other formats using headless Chromium that
contains the shared logic for all converters. This package is not intended to be used directly to convert SVGs and,
instead, provides core support for SVG conversion.

[![Build Status](https://img.shields.io/travis/neocotic/convert-svg/develop.svg?style=flat-square)](https://travis-ci.org/neocotic/convert-svg)
[![License](https://img.shields.io/github/license/neocotic/convert-svg.svg?style=flat-square)](https://github.com/neocotic/convert-svg/blob/master/LICENSE.md)
[![Release](https://img.shields.io/github/release/neocotic/convert-svg.svg?style=flat-square)](https://github.com/neocotic/convert-svg/tree/master/packages/convert-svg-core)

* [Install](#install)
* [Implementation](#implementation)
* [Testing](#testing)
* [Bugs](#bugs)
* [Contributors](#contributors)
* [License](#license)

## Install

If you are looking to install an out-of-the-box SVG converter, check out our converter packages below:

https://github.com/neocotic/convert-svg

Alternatively, if you know what you're doing, you can install using [npm](https://www.npmjs.com):

``` bash
$ npm install --save convert-svg-core
```

You'll need to have at least [Node.js](https://nodejs.org) 8 or newer.

If you're looking to create a converter for a new format, we'd urge you to consider contributing to this framework so
that it can be easily integrated and maintained. Read the [Contributors](#contributors) section for information on how
you can contribute.

## Implementation

In order to create a new SVG converter that uses `convert-svg-core`, you'll need to create a new sub-directory for your
package under the [packages](https://github.com/neocotic/convert-svg/tree/master/packages) directory. Try to follow the
`convert-svg-to-<FORMAT>` naming convention for the converter package name.

Take a look at the other packages in this directory to setup the new package directory. They are all very similar, by
design, as the you should just need to provide the minimal amount of information required to support your intended
output format.

The most important thing that's needed is a implementation of
[convert-svg-core/src/Provider](https://github.com/neocotic/convert-svg/blob/master/packages/convert-svg-core/src/Provider.js).
This is an abstract class and contains many methods that *must* be implemented. Read the JSDoc for these methods to
understand what's needed. If your intended output format requires additional configuration, make the necessary changes
to `convert-svg-core`, while ensuring that reuse and other converters are kept at the front of your mind.

With an implementation of `Provider` for your intended output format, you can now expose an `API` and `CLI` for it.

### API

Create a file for your package's main module (commonly `src/index.js`) to contain something like the following:

``` javascript
const { API } = require('convert-svg-core');

const MyFormatProvider = require('./MyFormatProvider');

module.exports = new API(new MyFormatProvider());
```  

Configure this in your `package.json` file and you're API is ready!

### CLI

Create a file for your CLI (commonly `bin/<PACKAGE-NAME>`) to contain something like the following:

``` javascript
#!/usr/bin/env node

const { CLI } = require('convert-svg-core');

const MyFormatProvider = require('../src/MyFormatProvider');

(async() => {
  const cli = new CLI(new MyFormatProvider());

  try {
    await cli.parse(process.argv);
  } catch (e) {
    cli.error(`<PACKAGE-NAME> failed: ${e.stack}`);

    process.exit(1);
  }
})();
```

Make sure that your file is executable. For example;

``` bash
$ chmod a+x bin/<PACKAGE-NAME>
```

Configure this in your `package.json` file and you're CLI is ready!

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
