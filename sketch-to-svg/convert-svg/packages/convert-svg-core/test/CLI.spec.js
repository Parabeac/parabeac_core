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
const { EOL } = require('os');
const sinon = require('sinon');
const { Writable } = require('stream');

const CLI = require('../src/CLI');
const Provider = require('../src/Provider');

describe('[convert-svg-core] CLI', () => {
  let cli;
  let errorStream;
  let outputStream;
  let provider;

  beforeEach(() => {
    errorStream = sinon.createStubInstance(Writable);
    outputStream = sinon.createStubInstance(Writable);

    provider = sinon.createStubInstance(Provider);
    provider.getVersion.returns('0.0.0');

    cli = new CLI(provider, {
      baseDir: __dirname,
      errorStream,
      outputStream
    });
  });

  describe('#error', () => {
    it('should write message to error stream', () => {
      cli.error('foo');

      assert.equal(outputStream.write.callCount, 0);
      assert.equal(errorStream.write.callCount, 1);
      assert.deepEqual(errorStream.write.args, [
        [ `foo${EOL}` ]
      ]);
    });
  });

  describe('#output', () => {
    it('should write message to output stream', () => {
      cli.output('foo');

      assert.equal(errorStream.write.callCount, 0);
      assert.equal(outputStream.write.callCount, 1);
      assert.deepEqual(outputStream.write.args, [
        [ `foo${EOL}` ]
      ]);
    });
  });

  describe('#parse', () => {
    // TODO: Test all CLI flows and options
  });

  describe('#provider', () => {
    it('should return provider', () => {
      assert.strictEqual(cli.provider, provider);
    });
  });
});
