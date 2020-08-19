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

const Provider = require('../src/Provider');

describe('[convert-svg-core] Provider', () => {
  const abstractMethods = [
    'getBackgroundColor',
    'getCLIOptions',
    'getScreenshotOptions',
    'getType',
    'getVersion',
    'parseAPIOptions',
    'parseCLIOptions'
  ];
  class TestProviderImpl extends Provider {

    /**
     * @inheritdoc
     * @override
     */
    getType() {
      return 'TyPe';
    }

  }

  abstractMethods.forEach((methodName) => {
    describe(`#${methodName}`, () => {
      it('should throw an error by default', () => {
        const provider = new Provider();

        assert.throws(() => {
          provider[methodName]();
        }, (error) => {
          return error instanceof Error &&
              error.message === `Provider#${methodName} abstract method is not implemented`;
        });
      });
    });
  });

  describe('#getExtension', () => {
    it('should return Provider#getType transformed into lower case by default', () => {
      const provider = new TestProviderImpl();

      assert.equal(provider.getExtension(), 'type');
    });
  });

  describe('#getFormat', () => {
    it('should return Provider#getType transformed into upper case by default', () => {
      const provider = new TestProviderImpl();

      assert.equal(provider.getFormat(), 'TYPE');
    });
  });
});
