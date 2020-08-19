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

'use strict';

const { Provider } = require('convert-svg-core');

const { version } = require('../package.json');

/**
 * A {@link Provider} implementation to support JPEG as an output format for SVG conversion.
 *
 * @public
 */
class JPEGProvider extends Provider {

  /**
   * @inheritdoc
   * @override
   */
  getBackgroundColor(options) {
    return options.background || '#FFF';
  }

  /**
   * @inheritdoc
   * @override
   */
  getCLIOptions() {
    return [
      {
        flags: '--quality <value>',
        description: `specify quality for ${this.getFormat()} [100]`,
        parseInt
      }
    ];
  }

  /**
   * @inheritdoc
   * @override
   */
  getScreenshotOptions(options) {
    return { quality: options.quality };
  }

  /**
   * @inheritdoc
   * @override
   */
  getType() {
    return 'jpeg';
  }

  /**
   * @inheritdoc
   * @override
   */
  getVersion() {
    return version;
  }

  /**
   * @inheritdoc
   * @override
   */
  parseAPIOptions(options) {
    if (typeof options.quality === 'number' && (options.quality < 0 || options.quality > 100)) {
      throw new Error('Value for quality option out of range. Use value between 0-100 (inclusive)');
    }
    if (options.quality == null) {
      options.quality = 100;
    }
  }

  /**
   * @inheritdoc
   * @override
   */
  parseCLIOptions(options, command) {
    options.quality = command.quality;
  }

}

module.exports = JPEGProvider;
