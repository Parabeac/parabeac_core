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
const PNGProvider = require('../src/PNGProvider');

describe('[convert-svg-to-png] PNGProvider', () => {
  let provider;

  before(() => {
    provider = new PNGProvider();
  });

  it('should extend Provider', () => {
    assert.ok(provider instanceof Provider);
  });

  describe('#getBackgroundColor', () => {
    context('when background option was not specified', () => {
      it('should return transparent color', () => {
        assert.equal(provider.getBackgroundColor({}), 'transparent');
      });
    });

    context('when background option was specified', () => {
      it('should return background', () => {
        assert.equal(provider.getBackgroundColor({ background: '#000' }), '#000');
      });
    });
  });

  describe('#getCLIOptions', () => {
    it('should return null', () => {
      assert.strictEqual(provider.getCLIOptions(), null);
    });
  });

  describe('#getExtension', () => {
    it('should return output file extension', () => {
      assert.equal(provider.getExtension(), 'png');
    });
  });

  describe('#getFormat', () => {
    it('should return output format', () => {
      assert.equal(provider.getFormat(), 'PNG');
    });
  });

  describe('#getScreenshotOptions', () => {
    context('when background option was not specified', () => {
      it('should return puppeteer screenshot options with background omitted', () => {
        assert.deepEqual(provider.getScreenshotOptions({}), { omitBackground: true });
      });
    });

    context('when background option was specified', () => {
      it('should return puppeteer screenshot options with background', () => {
        assert.deepEqual(provider.getScreenshotOptions({ background: '#000' }), { omitBackground: false });
      });
    });
  });

  describe('#getType', () => {
    it('should return output type supported as supported by puppeteer screenshots', () => {
      assert.equal(provider.getType(), 'png');
    });
  });

  describe('#getVersion', () => {
    it('should return version in package.json', () => {
      assert.equal(provider.getVersion(), pkg.version);
    });
  });

  describe('#parseAPIOptions', () => {
    it('should do nothing', () => {
      const options = {};

      provider.parseAPIOptions(options);

      assert.deepEqual(options, {});
    });
  });

  describe('#parseCLIOptions', () => {
    it('should do nothing', () => {
      const options = {};

      provider.parseCLIOptions(options);

      assert.deepEqual(options, {});
    });
  });
});
