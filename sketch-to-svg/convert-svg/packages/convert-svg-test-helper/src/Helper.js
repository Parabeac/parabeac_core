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
const cloneDeep = require('lodash.clonedeep');
const fileUrl = require('file-url');
const fs = require('fs');
const path = require('path');
const rimraf = require('rimraf');
const sinon = require('sinon');
const util = require('util');

const coreTests = require('./tests.json');

const makeDirectory = util.promisify(fs.mkdir);
const readFile = util.promisify(fs.readFile);
const removeFile = util.promisify(rimraf);
const writeFile = util.promisify(fs.writeFile);

const _api = Symbol('api');
const _baseDir = Symbol('baseDir');
const _getContext = Symbol('getContext');
const _parseOptions = Symbol('parseOptions');
const _provider = Symbol('provider');
const _tests = Symbol('tests');

/**
 * Contains helper methods for testing the core convert methods and to ensure consistency across all target formats.
 *
 * @public
 */
class Helper {

  static [_getContext](test) {
    return test.skip ? context.skip : context;
  }

  /**
   * Creates an instance of {@link Helper} using the <code>options</code> provided.
   *
   * @param {Helper~Options} options - the options to be used
   * @public
   */
  constructor(options) {
    const tests = coreTests.map((test) => {
      test = cloneDeep(test);
      test.core = true;

      return test;
    });
    if (options.tests) {
      options.tests.forEach((test) => tests.push(cloneDeep(test)));
    }

    this[_tests] = tests;
    this[_api] = options.api;
    this[_baseDir] = options.baseDir;
    this[_provider] = options.provider;
  }

  /**
   * Creates fixture files within the <code>fixtures/actual</code> directory for each test.
   *
   * This method can be extremely useful for creating expected files for new fixtures, updating existing ones after
   * changes/improvements within Chromium, and primarily to debug tests failing due to mismatched buffers since a visual
   * comparison is more likely to help than comparing bytes.
   *
   * Error tests are ignored as they have no expected output.
   *
   * An error will occur if any problem arises while loading the tests or trying to read/write any files or convert an
   * SVG into another format.
   *
   * @return {Promise.<void, Error>} A <code>Promise</code> that is resolved once all fixture files have been created.
   * @public
   */
  async createFixtures() {
    const converter = this.api.createConverter();
    const extension = this.provider.getExtension();
    let index = -1;

    try {
      await makeDirectory(path.join(this.baseDir, 'fixtures', 'actual'));
    } catch (e) {
      if (e.code !== 'EEXIST') {
        throw e;
      }
    }

    try {
      for (const test of this[_tests]) {
        index++;

        if (test.error) {
          continue;
        }

        const inputFilePath = path.join(test.core ? __dirname : this.baseDir, 'fixtures', 'input', test.file);
        const input = await readFile(inputFilePath);
        const opts = this[_parseOptions](test, inputFilePath);

        const actualFilePath = path.join(this.baseDir, 'fixtures', 'actual', `${index}.${extension}`);
        const actual = await converter.convert(input, opts);

        await writeFile(actualFilePath, actual);
      }
    } finally {
      await converter.destroy();
    }
  }

  /**
   * Describes each test for the <code>convertFile</code> method.
   *
   * Optionally, <code>testAPI</code> can be specified to control whether {@link API#convertFile} or
   * {@link Converter#convertFile} are tested.
   *
   * @param {boolean} [testAPI] - <code>true</code> to test {@link API#convertFile}; otherwise <code>false</code> to
   * test {@link Converter#convertFile}
   * @return {void}
   * @public
   */
  describeConvertFileTests(testAPI) {
    const { api } = this;
    let converter;
    const helper = this;

    before(async() => {
      try {
        await makeDirectory(path.join(helper.baseDir, 'fixtures', 'actual'));
      } catch (e) {
        if (e.code !== 'EEXIST') {
          throw e;
        }
      }
    });

    after(async() => {
      await removeFile(path.join(helper.baseDir, 'fixtures', 'actual'), { glob: false });
    });

    if (testAPI) {
      beforeEach(() => {
        converter = api.createConverter();

        sinon.spy(converter, 'destroy');
        sinon.stub(api, 'createConverter').returns(converter);
      });

      afterEach(() => {
        assert.equal(api.createConverter.callCount, 1);
        assert.equal(converter.destroy.callCount, 1);
      });

      afterEach(() => {
        api.createConverter.restore();
      });
    } else {
      before(() => {
        converter = api.createConverter();
      });

      after(async() => {
        await converter.destroy();
      });
    }

    this[_tests].forEach((test, index) => {
      Helper[_getContext](test)(`(test:${index}) ${test.name}`, function() {
        /* eslint-disable no-invalid-this */
        this.slow(testAPI ? 600 : 250);
        /* eslint-enable no-invalid-this */

        const message = test.error ? 'should throw an error' : test.message;

        let outputFilePath;
        let inputFilePath;
        let options;
        let expectedFilePath;
        let expected;

        before(async() => {
          const extension = helper.provider.getExtension();
          outputFilePath = path.join(helper.baseDir, 'fixtures', 'actual', `${index}.${extension}`);
          inputFilePath = path.join(test.core ? __dirname : helper.baseDir, 'fixtures', 'input', test.file);
          options = helper[_parseOptions](test, inputFilePath, outputFilePath);

          if (!test.error) {
            expectedFilePath = path.join(helper.baseDir, 'fixtures', 'expected', `${index}.${extension}`);
            expected = await readFile(expectedFilePath);
          }
        });

        it(message, async() => {
          const method = testAPI ? api.convertFile.bind(api) : converter.convertFile.bind(converter);

          if (test.error) {
            try {
              await method(inputFilePath, options);
              // Should have thrown
              assert.fail();
            } catch (e) {
              assert.equal(e.message, test.error);
            }
          } else {
            const actualFilePath = await method(inputFilePath, options);
            const actual = await readFile(outputFilePath);

            assert.equal(actualFilePath, outputFilePath);
            assert.deepEqual(actual, expected);
          }
        });
      });
    });
  }

  /**
   * Describes each test for the <code>convert</code> method.
   *
   * Optionally, <code>testAPI</code> can be specified to control whether {@link API#convert} or
   * {@link Converter#convert} are tested.
   *
   * @param {boolean} [testAPI] - <code>true</code> to test {@link API#convert}; otherwise <code>false</code> to test
   * {@link Converter#convert}
   * @return {void}
   * @public
   */
  describeConvertTests(testAPI) {
    const { api } = this;
    let converter;
    const helper = this;

    if (testAPI) {
      beforeEach(() => {
        converter = api.createConverter();

        sinon.spy(converter, 'destroy');
        sinon.stub(api, 'createConverter').returns(converter);
      });

      afterEach(() => {
        assert.equal(api.createConverter.callCount, 1);
        assert.equal(converter.destroy.callCount, 1);
      });

      afterEach(() => {
        api.createConverter.restore();
      });
    } else {
      before(() => {
        converter = api.createConverter();
      });

      after(async() => {
        await converter.destroy();
      });
    }

    this[_tests].forEach((test, index) => {
      Helper[_getContext](test)(`(test:${index}) ${test.name}`, function() {
        /* eslint-disable no-invalid-this */
        this.slow(testAPI ? 550 : 200);
        /* eslint-enable no-invalid-this */

        const message = test.error ? 'should throw an error' : test.message;

        let inputFilePath;
        let input;
        let options;
        let expectedFilePath;
        let expected;

        before(async() => {
          const extension = helper.provider.getExtension();
          inputFilePath = path.join(test.core ? __dirname : helper.baseDir, 'fixtures', 'input', test.file);
          input = await readFile(inputFilePath);
          options = helper[_parseOptions](test, inputFilePath);

          if (!test.error) {
            expectedFilePath = path.join(helper.baseDir, 'fixtures', 'expected', `${index}.${extension}`);
            expected = await readFile(expectedFilePath);
          }
        });

        it(message, async() => {
          const method = testAPI ? api.convert.bind(api) : converter.convert.bind(converter);

          if (test.error) {
            try {
              await method(input, options);
              // Should have thrown
              assert.fail();
            } catch (e) {
              assert.equal(e.message, test.error);
            }
          } else {
            const actual = await method(input, options);

            assert.deepEqual(actual, expected);
          }
        });
      });
    });

    context(`(test:${this[_tests].length}) when input is a string`, function() {
      /* eslint-disable no-invalid-this */
      this.slow(testAPI ? 350 : 200);
      /* eslint-enable no-invalid-this */

      let inputFilePath;
      let input;
      let expectedFilePath;
      let expected;

      before(async() => {
        const extension = helper.provider.getExtension();
        const test = helper[_tests].find((t) => !t.error);

        inputFilePath = path.join(test.core ? __dirname : helper.baseDir, 'fixtures', 'input', test.file);
        input = await readFile(inputFilePath, 'utf8');
        expectedFilePath = path.join(helper.baseDir, 'fixtures', 'expected', `0.${extension}`);
        expected = await readFile(expectedFilePath);
      });

      it('should convert SVG string to converted output buffer', async() => {
        const method = testAPI ? api.convert.bind(api) : converter.convert.bind(converter);
        const actual = await method(input);

        assert.deepEqual(actual, expected);
      });
    });
  }

  [_parseOptions](test, inputFilePath, outputFilePath) {
    const options = Object.assign({}, test.options);
    if (outputFilePath) {
      options.outputFilePath = outputFilePath;
    }

    if (test.includeBaseFile) {
      options.baseFile = inputFilePath;
    }
    if (test.includeBaseUrl) {
      options.baseUrl = fileUrl(inputFilePath);
    }

    return options;
  }

  /**
   * Returns this {@link API} being tested by this {@link Helper}.
   *
   * @return {API} The API.
   * @public
   */
  get api() {
    return this[_api];
  }

  /**
   * Returns the path of the base directory of the tests for this {@link Helper}.
   *
   * @return {string} The base directory.
   * @public
   */
  get baseDir() {
    return this[_baseDir];
  }

  /**
   * Returns the {@link Provider} being tested by this {@link Helper}.
   *
   * @return {Provider} The provider.
   * @public
   */
  get provider() {
    return this[_provider];
  }

  /**
   * Returns a copy of the tests for this {@link Helper}.
   *
   * @return {Helper~Test[]} The tests.
   * @public
   */
  get tests() {
    return this[_tests].slice();
  }

}

module.exports = Helper;

/**
 * The options that can be passed to {@link Helper}.
 *
 * @typedef {Object} Helper~Options
 * @property {API} api - The {@link API} to be tested.
 * @property {string} baseDir - The path of the base directory of the tests.
 * @property {Provider} provider - The {@link Provider} to be tested.
 * @property {?Array.<Helper~Test>} [tests] - The tests to be ran after the core tests.
 */

/**
 * Describes a test involving a fixture file.
 *
 * Either <code>error</code> or <code>message</code> must be specified, but not both.
 *
 * @typedef {Object} Helper~Test
 * @property {boolean} [core] - <code>true</code> if this test is internal to <code>convert-svg-test-helper</code>
 * module; otherwise <code>false</code>.
 * @property {string} [error] - The message for the error expected to be thrown as a result of running this test. Cannot
 * be specified if <code>message</code> has also been specified.
 * @property {string} file - The name of the fixture file to be used for this test.
 * @property {boolean} [includeBaseFile] - <code>true</code> if the <code>baseFile</code> option is to be added to the
 * options; otherwise <code>false</code>.
 * @property {boolean} [includeBaseUrl] - <code>true</code> if the <code>baseUrl</code> option is to be added to the
 * options; otherwise <code>false</code>.
 * @property {string} [message] - The message describing this test. Cannot be specified if <code>error</code> has also
 * been specified.
 * @property {string} name - The name of this test.
 * @property {Converter~ConvertOptions} [options] - The options to be passed to the convert method. May be modified if
 * either <code>includeBaseFile</code> or <code>includeBaseUrl</code> are enabled.
 */
