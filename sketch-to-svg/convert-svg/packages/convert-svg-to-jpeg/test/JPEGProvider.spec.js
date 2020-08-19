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

const assert = require('assert');
const { Provider } = require('convert-svg-core');

const pkg = require('../package.json');
const JPEGProvider = require('../src/JPEGProvider');

describe('[convert-svg-to-jpeg] JPEGProvider', () => {
  let provider;

  before(() => {
    provider = new JPEGProvider();
  });

  it('should extend Provider', () => {
    assert.ok(provider instanceof Provider);
  });

  describe('#getBackgroundColor', () => {
    context('when background option was not specified', () => {
      it('should return white color', () => {
        assert.equal(provider.getBackgroundColor({}), '#FFF');
      });
    });

    context('when background option was specified', () => {
      it('should return background', () => {
        assert.equal(provider.getBackgroundColor({ background: '#000' }), '#000');
      });
    });
  });

  describe('#getCLIOptions', () => {
    it('should return CLI options', () => {
      assert.deepEqual(provider.getCLIOptions(), [
        {
          flags: '--quality <value>',
          description: 'specify quality for JPEG [100]',
          parseInt
        }
      ]);
    });
  });

  describe('#getExtension', () => {
    it('should return output file extension', () => {
      assert.equal(provider.getExtension(), 'jpeg');
    });
  });

  describe('#getFormat', () => {
    it('should return output format', () => {
      assert.equal(provider.getFormat(), 'JPEG');
    });
  });

  describe('#getScreenshotOptions', () => {
    it('should return puppeteer screenshot options with quality option', () => {
      assert.deepEqual(provider.getScreenshotOptions({ quality: 50 }), { quality: 50 });
    });
  });

  describe('#getType', () => {
    it('should return output type supported as supported by puppeteer screenshots', () => {
      assert.equal(provider.getType(), 'jpeg');
    });
  });

  describe('#getVersion', () => {
    it('should return version in package.json', () => {
      assert.equal(provider.getVersion(), pkg.version);
    });
  });

  describe('#parseAPIOptions', () => {
    context('when quality option is missing', () => {
      it('should populate default value for quality option', () => {
        const options = {};

        provider.parseAPIOptions(options);

        assert.deepEqual(options, { quality: 100 });
      });
    });

    context('when quality option is valid', () => {
      it('should do nothing', () => {
        const options = { quality: 0 };

        provider.parseAPIOptions(options);

        assert.deepEqual(options, { quality: 0 });

        options.quality = 50;

        provider.parseAPIOptions(options);

        assert.deepEqual(options, { quality: 50 });

        options.quality = 100;

        provider.parseAPIOptions(options);

        assert.deepEqual(options, { quality: 100 });
      });
    });

    context('when quality option is out of range', () => {
      it('should throw an error', () => {
        assert.throws(() => {
          provider.parseAPIOptions({ quality: -1 });
        }, (error) => {
          return error instanceof Error &&
              error.message === 'Value for quality option out of range. Use value between 0-100 (inclusive)';
        });

        assert.throws(() => {
          provider.parseAPIOptions({ quality: 101 });
        }, (error) => {
          return error instanceof Error &&
              error.message === 'Value for quality option out of range. Use value between 0-100 (inclusive)';
        });
      });
    });
  });

  describe('#parseCLIOptions', () => {
    it('should extract quality CLI option', () => {
      const options = {};

      provider.parseCLIOptions(options, {});

      assert.strictEqual(options.quality, undefined);

      provider.parseCLIOptions(options, { quality: 50 });

      assert.equal(options.quality, 50);
    });
  });
});
