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

/* global document: false */

const fileUrl = require('file-url');
const fs = require('fs');
const path = require('path');
const puppeteer = require('puppeteer');
process.setMaxListeners(Infinity);
const tmp = require('tmp');
const util = require('util');

const readFile = util.promisify(fs.readFile);
const writeFile = util.promisify(fs.writeFile);

const _browser = Symbol('browser');
const _convert = Symbol('convert');
const _destroyed = Symbol('destroyed');
const _getDimensions = Symbol('getDimensions');
const _getPage = Symbol('getPage');
const _getTempFile = Symbol('getTempFile');
const _options = Symbol('options');
const _page = Symbol('page');
const _parseOptions = Symbol('parseOptions');
const _provider = Symbol('provider');
const _setDimensions = Symbol('setDimensions');
const _tempFile = Symbol('tempFile');
const _validate = Symbol('validate');

/**
 * Converts SVG to another format using a headless Chromium instance.
 *
 * It is important to note that, after the first time either {@link Converter#convert} or{@link Converter#convertFile}
 * are called, a headless Chromium instance will remain open until {@link Converter#destroy} is called. This is done
 * automatically when using the {@link API} convert methods, however, when using {@link Converter} directly, it is the
 * responsibility of the caller. Due to the fact that creating browser instances is expensive, this level of control
 * allows callers to reuse a browser for multiple conversions. For example; one could create a {@link Converter} and use
 * it to convert a collection of SVG files to files in another format and then destroy it afterwards. It's not
 * recommended to keep an instance around for too long, as it will use up resources.
 *
 * Due constraints within Chromium, the SVG input is first written to a temporary HTML file and then navigated to. This
 * is because the default page for Chromium is using the <code>chrome</code> protocol so cannot load externally
 * referenced files (e.g. that use the <code>file</code> protocol). This temporary file is reused for the lifespan of
 * each {@link Converter} instance and will be deleted when it is destroyed.
 *
 * It's also the responsibility of the caller to ensure that all {@link Converter} instances are destroyed before the
 * process exits. This is why a short-lived {@link Converter} instance combined with a try/finally block is ideal.
 *
 * @public
 */
class Converter {

  /**
   * Creates an instance of {@link Converter} using the specified <code>provider</code> and the <code>options</code>
   * provided.
   *
   * @param {Provider} provider - the {@link Provider} to be used
   * @param {Converter~Options} [options] - the options to be used
   * @public
   */
  constructor(provider, options) {
    this[_provider] = provider;
    this[_options] = Object.assign({}, options);
    this[_destroyed] = false;
  }

  /**
   * Converts the specified <code>input</code> SVG into another format using the <code>options</code> provided.
   *
   * <code>input</code> can either be a SVG buffer or string.
   *
   * If the width and/or height cannot be derived from <code>input</code> then they must be provided via their
   * corresponding options. This method attempts to derive the dimensions from <code>input</code> via any
   * <code>width</code>/<code>height</code> attributes or its calculated <code>viewBox</code> attribute.
   *
   * This method is resolved with the converted output buffer.
   *
   * An error will occur if this {@link Converter} has been destroyed, both the <code>baseFile</code> and
   * <code>baseUrl</code> options have been provided, <code>input</code> does not contain an SVG element, or no
   * <code>width</code> and/or <code>height</code> options were provided and this information could not be derived from
   * <code>input</code>.
   *
   * @param {Buffer|string} input - the SVG input to be converted to another format
   * @param {Converter~ConvertOptions} [options] - the options to be used
   * @return {Promise.<Buffer, Error>} A <code>Promise</code> that is resolved with the converted output buffer.
   * @public
   */
  async convert(input, options) {
    this[_validate]();

    options = this[_parseOptions](options);

    const output = await this[_convert](input, options);

    return output;
  }

  /**
   * Converts the SVG file at the specified path into another format using the <code>options</code> provided and writes
   * it to the output file.
   *
   * The output file is derived from <code>inputFilePath</code> unless the <code>outputFilePath</code> option is
   * specified.
   *
   * If the width and/or height cannot be derived from the input file then they must be provided via their corresponding
   * options. This method attempts to derive the dimensions from the input file via any
   * <code>width</code>/<code>height</code> attributes or its calculated <code>viewBox</code> attribute.
   *
   * This method is resolved with the path of the converted output file for reference.
   *
   * An error will occur if this {@link Converter} has been destroyed, both the <code>baseFile</code> and
   * <code>baseUrl</code> options have been provided, the input file does not contain an SVG element, no
   * <code>width</code> and/or <code>height</code> options were provided and this information could not be derived from
   * input file, or a problem arises while reading the input file or writing the output file.
   *
   * @param {string} inputFilePath - the path of the SVG file to be converted to another file format
   * @param {Converter~ConvertFileOptions} [options] - the options to be used
   * @return {Promise.<string, Error>} A <code>Promise</code> that is resolved with the output file path.
   * @public
   */
  async convertFile(inputFilePath, options) {
    this[_validate]();

    options = this[_parseOptions](options, inputFilePath);

    const input = await readFile(inputFilePath);
    const output = await this[_convert](input, options);

    await writeFile(options.outputFilePath, output);

    return options.outputFilePath;
  }

  /**
   * Destroys this {@link Converter}.
   *
   * This will close any headless Chromium browser that has been opend by this {@link Converter} as well as deleting any
   * temporary file that it may have created.
   *
   * Once destroyed, this {@link Converter} should be discarded and a new one created, if needed.
   *
   * An error will occur if any problem arises while closing the browser, where applicable.
   *
   * @return {Promise.<void, Error>} A <code>Promise</code> that is resolved once this {@link Converter} has been
   * destroyed.
   * @public
   */
  async destroy() {
    if (this[_destroyed]) {
      return;
    }

    this[_destroyed] = true;

    if (this[_tempFile]) {
      this[_tempFile].cleanup();
      delete this[_tempFile];
    }
    if (this[_browser]) {
      await this[_browser].close();
      delete this[_browser];
      delete this[_page];
    }
  }

  async [_convert](input, options) {
    input = Buffer.isBuffer(input) ? input.toString('utf8') : input;

    const { provider } = this;
    const start = input.indexOf('<svg');

    let html = `<!DOCTYPE html>
<base href="${options.baseUrl}">
<style>
* { margin: 0; padding: 0; }
html { background-color: ${provider.getBackgroundColor(options)}; }
</style>`;
    if (start >= 0) {
      html += input.substring(start);
    } else {
      throw new Error('SVG element open tag not found in input. Check the SVG input');
    }

    const page = await this[_getPage](html);

    await this[_setDimensions](page, options);

    const dimensions = await this[_getDimensions](page);
    if (!dimensions) {
      throw new Error('Unable to derive width and height from SVG. Consider specifying corresponding options');
    }

    if (options.scale !== 1) {
      dimensions.height *= options.scale;
      dimensions.width *= options.scale;

      await this[_setDimensions](page, dimensions);
    }

    await page.setViewport({
      height: Math.round(dimensions.height),
      width: Math.round(dimensions.width)
    });

    const output = await page.screenshot(Object.assign({
      type: provider.getType(),
      clip: Object.assign({ x: 0, y: 0 }, dimensions)
    }, provider.getScreenshotOptions(options)));

    return output;
  }

  [_getDimensions](page) {
    return page.evaluate(() => {
      const el = document.querySelector('svg');
      if (!el) {
        return null;
      }

      const widthIsPercent = (el.getAttribute('width') || '').endsWith('%');
      const heightIsPercent = (el.getAttribute('height') || '').endsWith('%');
      const width = !widthIsPercent && parseFloat(el.getAttribute('width'));
      const height = !heightIsPercent && parseFloat(el.getAttribute('height'));

      if (width && height) {
        return { width, height };
      }

      const viewBoxWidth = el.viewBox.animVal.width;
      const viewBoxHeight = el.viewBox.animVal.height;

      if (width && viewBoxHeight) {
        return {
          width,
          height: width * viewBoxHeight / viewBoxWidth
        };
      }

      if (height && viewBoxWidth) {
        return {
          width: height * viewBoxWidth / viewBoxHeight,
          height
        };
      }

      return null;
    });
  }

  async [_getPage](html) {
    if (!this[_browser]) {
      this[_browser] = await puppeteer.launch(this[_options].puppeteer);
      this[_page] = await this[_browser].newPage();
    }

    const tempFile = await this[_getTempFile]();

    await writeFile(tempFile.path, html);

    await this[_page].goto(fileUrl(tempFile.path));

    return this[_page];
  }

  [_getTempFile]() {
    if (this[_tempFile]) {
      return Promise.resolve(this[_tempFile]);
    }

    return new Promise((resolve, reject) => {
      tmp.file({ prefix: 'convert-svg-', postfix: '.html' }, (error, filePath, fd, cleanup) => {
        if (error) {
          reject(error);
        } else {
          this[_tempFile] = { path: filePath, cleanup };

          resolve(this[_tempFile]);
        }
      });
    });
  }

  [_parseOptions](options, inputFilePath) {
    options = Object.assign({}, options);

    const { provider } = this;

    if (!options.outputFilePath && inputFilePath) {
      const extension = `.${provider.getExtension()}`;
      const outputDirPath = path.dirname(inputFilePath);
      const outputFileName = `${path.basename(inputFilePath, path.extname(inputFilePath))}${extension}`;

      options.outputFilePath = path.join(outputDirPath, outputFileName);
    }

    if (options.baseFile != null && options.baseUrl != null) {
      throw new Error('Both baseFile and baseUrl options specified. Use only one');
    }
    if (typeof options.baseFile === 'string') {
      options.baseUrl = fileUrl(options.baseFile);
      delete options.baseFile;
    }
    if (!options.baseUrl) {
      options.baseUrl = fileUrl(inputFilePath ? path.resolve(inputFilePath) : process.cwd());
    }

    if (typeof options.height === 'string') {
      options.height = parseInt(options.height, 10);
    }
    if (options.scale == null) {
      options.scale = 1;
    }
    if (typeof options.width === 'string') {
      options.width = parseInt(options.width, 10);
    }

    provider.parseAPIOptions(options, inputFilePath);

    return options;
  }

  async [_setDimensions](page, dimensions) {
    if (typeof dimensions.width !== 'number' && typeof dimensions.height !== 'number') {
      return;
    }

    await page.evaluate(({ width, height }) => {
      const el = document.querySelector('svg');
      if (!el) {
        return;
      }

      if (typeof width === 'number') {
        el.setAttribute('width', `${width}px`);
      } else {
        el.removeAttribute('width');
      }

      if (typeof height === 'number') {
        el.setAttribute('height', `${height}px`);
      } else {
        el.removeAttribute('height');
      }
    }, dimensions);
  }

  [_validate]() {
    if (this[_destroyed]) {
      throw new Error('Converter has been destroyed. A new Converter must be created');
    }
  }

  /**
   * Returns whether this {@link Converter} has been destroyed.
   *
   * @return {boolean} <code>true</code> if destroyed; otherwise <code>false</code>.
   * @see {@link Converter#destroy}
   * @public
   */
  get destroyed() {
    return this[_destroyed];
  }

  /**
   * Returns the {@link Provider} for this {@link Converter}.
   *
   * @return {Provider} The provider.
   * @public
   */
  get provider() {
    return this[_provider];
  }

}

module.exports = Converter;

/**
 * The options that can be passed to {@link Converter#convertFile}.
 *
 * @typedef {Converter~ConvertOptions} Converter~ConvertFileOptions
 * @property {string} [outputFilePath] - The path of the file to which the output should be written to. By default, this
 * will be derived from the input file path.
 */

/**
 * The options that can be passed to {@link Converter#convert}.
 *
 * @typedef {Object} Converter~ConvertOptions
 * @property {string} [background] - The background color to be used to fill transparent regions within the SVG. If
 * omitted, the {@link Provider} will determine the default background color.
 * @property {string} [baseFile] - The path of the file to be converted into a file URL to use for all relative URLs
 * contained within the SVG. Cannot be used in conjunction with the <code>baseUrl</code> option.
 * @property {string} [baseUrl] - The base URL to use for all relative URLs contained within the SVG. Cannot be used in
 * conjunction with the <code>baseFile</code> option.
 * @property {number|string} [height] - The height of the output to be generated. If omitted, an attempt will be made to
 * derive the height from the SVG input.
 * @property {number} [scale=1] - The scale to be applied to the width and height (either specified as options or
 * derived).
 * @property {number|string} [width] - The width of the output to be generated. If omitted, an attempt will be made to
 * derive the width from the SVG input.
 */

/**
 * The options that can be passed to {@link Converter}.
 *
 * @typedef {Object} Converter~Options
 * @property {Object} [puppeteer] - The options that are to be passed directly to <code>puppeteer.launch</code> when
 * creating the <code>Browser</code> instance.
 */
