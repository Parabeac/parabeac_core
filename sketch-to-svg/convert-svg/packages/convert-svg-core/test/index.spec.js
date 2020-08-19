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

const API = require('../src/API');
const CLI = require('../src/CLI');
const Converter = require('../src/Converter');
const index = require('../src/index');
const Provider = require('../src/Provider');

describe('[convert-svg-core] index', () => {
  describe('.API', () => {
    it('should be a reference to API constructor', () => {
      assert.strictEqual(index.API, API, 'Must be API constructor');
    });
  });

  describe('.CLI', () => {
    it('should be a reference to CLI constructor', () => {
      assert.strictEqual(index.CLI, CLI, 'Must be CLI constructor');
    });
  });

  describe('.Converter', () => {
    it('should be a reference to Converter constructor', () => {
      assert.strictEqual(index.Converter, Converter, 'Must be Converter constructor');
    });
  });

  describe('.Provider', () => {
    it('should be a reference to Provider constructor', () => {
      assert.strictEqual(index.Provider, Provider, 'Must be Provider constructor');
    });
  });
});
