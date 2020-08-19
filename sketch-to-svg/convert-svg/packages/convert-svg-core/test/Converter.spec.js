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
const sinon = require('sinon');

const Converter = require('../src/Converter');
const Provider = require('../src/Provider');

describe('[convert-svg-core] Converter', () => {
  let converter;
  let provider;

  beforeEach(() => {
    provider = sinon.createStubInstance(Provider);
    converter = new Converter(provider);
  });

  afterEach(async() => {
    await converter.destroy();
  });

  describe('#convert', () => {
    // Primarily covered by convert-svg-test-helper

    context('when destroyed', () => {
      it('should thrown an error', async() => {
        await converter.destroy();

        try {
          await converter.convert('<svg></svg>');
          // Should have thrown
          assert.fail();
        } catch (e) {
          assert.equal(e.message, 'Converter has been destroyed. A new Converter must be created');
        }
      });
    });
  });

  describe('#convertFile', () => {
    // Primarily covered by convert-svg-test-helper

    context('when destroyed', () => {
      it('should thrown an error', async() => {
        await converter.destroy();

        try {
          await converter.convertFile('foo.svg');
          // Should have thrown
          assert.fail();
        } catch (e) {
          assert.equal(e.message, 'Converter has been destroyed. A new Converter must be created');
        }
      });
    });
  });

  describe('#destroy', () => {
    it('should destroy the converter', async() => {
      assert.equal(converter.destroyed, false);

      await converter.destroy();

      assert.equal(converter.destroyed, true);
    });
  });

  describe('#destroyed', () => {
    it('should indicate whether converter has been destroyed', async() => {
      assert.equal(converter.destroyed, false);

      await converter.destroy();

      assert.equal(converter.destroyed, true);
    });
  });

  describe('#provider', () => {
    it('should return provider', () => {
      assert.strictEqual(converter.provider, provider);
    });
  });
});
