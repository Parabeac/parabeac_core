# Contributing

If you have any questions about this library please feel free to
[raise an issue](https://github.com/neocotic/convert-svg/issues/new).

Please [search existing issues](https://github.com/neocotic/convert-svg/issues) for the same feature and/or issue before
raising a new issue. Commenting on an existing issue is usually preferred over raising duplicate issues.

Please ensure that all files conform to the coding standards, using the same coding style as the rest of the code base.
All unit tests should be updated and passing as well. All of this can easily be checked via command-line:

``` bash
# install/update package dependencies
$ npm install
$ npm run bootstrap
# run test suite
$ npm test
```

You must have at least [Node.js](https://nodejs.org) version 8 or newer installed.

Some of the test fixtures include Microsoft-based fonts so, if you're a non-Windows user, you will have to ensure that
you have Microsoft fonts installed. For example; Ubuntu users can do the following:

``` bash
$ sudo apt-get update
$ sudo apt-get install ttf-mscorefonts-installer -y
$ sudo fc-cache -fv
```

All pull requests should be made to the `develop` branch.

Don't forget to add your details to the list of
[AUTHORS.md](https://github.com/neocotic/convert-svg/blob/master/AUTHORS.md) if you want your contribution to be
recognized by others.
