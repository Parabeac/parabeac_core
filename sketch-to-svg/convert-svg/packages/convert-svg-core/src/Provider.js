/*
 * Copyright (C) 2018 Alasdair Mercer
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

// 'use strict';

const pollock = require('pollock');

/**
 * Supports a single output format for SVG conversion.
 *
 * @public
 * @abstract
 */
class Provider {

  /**
   * Returns the extension to be used for converted output files.
   *
   * By default, this method will return {@link Provider#getType} in lower case, however, implementations are free to
   * override this behavior, if required.
   *
   * @return {string} The output file extension.
   * @public
   */
  getExtension() {
    return this.getType().toLowerCase();
  }

  /**
   * Returns the human-friendly output format.
   *
   * This is primarily intended for feedback purposes (e.g. displaying the output format).
   *
   * By default, this method will return {@link Provider#getType} in upper case, however, implementations are free to
   * override this behavior, if required.
   *
   * @return {string} The output format.
   * @public
   */
  getFormat() {
    return this.getType().toUpperCase();
  }

}

/**
 * Returns the background color to be used by the HTML page containing the SVG based on the <code>options</code>
 * provided.
 *
 * The background color will only be applied to transparent sections of the SVG, if any.
 *
 * All implementations of {@link Provider} <b>must</b> override this method.
 *
 * @param {Converter~ConvertOptions} options - the parsed convert options
 * @return {string} The background color.
 * @public
 * @abstract
 * @memberof Provider#
 * @method getBackgroundColor
 */
pollock(Provider, 'getBackgroundColor');

/**
 * Returns any additional CLI options that are supported by this {@link Provider} on top of the core CLI options.
 *
 * This method may return <code>null</code> or an empty array to indicate that no additional CLI options are available.
 *
 * All implementations of {@link Provider} <b>must</b> override this method.
 *
 * @return {?Array.<CLI~Option>} Any additional CLI options or <code>null</code> if there are none.
 * @public
 * @abstract
 * @memberof Provider#
 * @method getCLIOptions
 */
pollock(Provider, 'getCLIOptions');

/**
 * Returns any additional options that are to be passed to <code>puppeteer</code>'s <code>Page#screenshot</code> method
 * based on the <code>options</code> provided.
 *
 * This method may return <code>null</code> or an empty object to indicate that no additional options are to be passed
 * and any options returned by this method will override the core options, where applicable.
 *
 * All implementations of {@link Provider} <b>must</b> override this method.
 *
 * @param {Converter~ConvertOptions} options - the parsed convert options
 * @return {?Object} Any additional options for <code>Page#screenshot</code> or <code>null</code> if there are none.
 * @public
 * @abstract
 * @memberof Provider#
 * @method getScreenshotOptions
 */
pollock(Provider, 'getScreenshotOptions');

/**
 * Returns the output type as supported by <code>puppeteer</code>'s <code>Page#screenshot</code> method.
 *
 * All implementations of {@link Provider} <b>must</b> override this method.
 *
 * @return {string} The output type.
 * @public
 * @abstract
 * @memberof Provider#
 * @method getType
 */
pollock(Provider, 'getType');

/**
 * Returns the version of the package containing this {@link Provider}.
 *
 * All implementations of {@link Provider} <b>must</b> override this method.
 *
 * @return {string} The version.
 * @public
 * @abstract
 * @memberof Provider#
 * @method getVersion
 */
pollock(Provider, 'getVersion');

/**
 * Parses and validates the specified <code>options</code> for {@link API}.
 *
 * This method should limit the options that it parses/validates to only those added by this {@link Provider} and leave
 * the core options as-is.
 *
 * An error will occur if any of the options are invalid.
 *
 * All implementations of {@link Provider} <b>must</b> override this method.
 *
 * @param {Object} options - the options to be parsed
 * @param {?string} inputFilePath - the path of the SVG file to be converted
 * @return {void}
 * @throws {Error} If any of <code>options</code> are invalid.
 * @public
 * @abstract
 * @memberof Provider#
 * @method parseAPIOptions
 */
pollock(Provider, 'parseAPIOptions');

/**
 * Parses the specified the specified <code>command</code> for {@link CLI} into options for {@link API}.
 *
 * This method should limit the options that it parses to only those added by this {@link Provider} and leave the core
 * options as-is.
 *
 * Validation does not need to be performed by this method as this should be done by {@link Provider#parseAPIOptions}.
 *
 * All implementations of {@link Provider} <b>must</b> override this method.
 *
 * @param {Object} options - the object on which the parsed options are to be added
 * @param {Command} command - the <code>Command</code> from which the options are to be parsed
 * @return {void}
 * @public
 * @abstract
 * @memberof Provider#
 * @method parseCLIOptions
 */
pollock(Provider, 'parseCLIOptions');

module.exports = Provider;
