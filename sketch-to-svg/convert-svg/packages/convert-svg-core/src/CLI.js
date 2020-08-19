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

const chalk = require('chalk');
const { Command } = require('commander');
const { EOL } = require('os');
const fs = require('fs');
const getStdin = require('get-stdin').buffer;
const glob = require('glob');
const omit = require('lodash.omit');
const path = require('path');
const pick = require('lodash.pick');
const util = require('util');

const Converter = require('./Converter');

const findFiles = util.promisify(glob);
const writeFile = util.promisify(fs.writeFile);

const _applyOptions = Symbol('applyOptions');
const _baseDir = Symbol('baseDir');
const _command = Symbol('command');
const _convertFiles = Symbol('convertFiles');
const _convertInput = Symbol('convertInput');
const _errorStream = Symbol('errorStream');
const _outputStream = Symbol('outputStream');
const _parseOptions = Symbol('parseOptions');
const _provider = Symbol('provider');

/**
 * The command line interface for a SVG converter {@link Provider}.
 *
 * While technically part of the API, this is not expected to be used outside of this package as it's only intended use
 * is by <code>bin/convert-svg-to-*</code>.
 *
 * @public
 */
class CLI {

  /**
   * Creates an instance of {@link CLI} with the specified <code>provider</code>.
   *
   * <code>options</code> is primarily intended for testing purposes and it's not expected to be supplied in any
   * real-world scenario.
   *
   * @param {Provider} provider - the {@link Provider} to be used
   * @param {CLI~Options} [options] - the options to be used
   * @public
   */
  constructor(provider, options = {}) {
    this[_provider] = provider;
    this[_baseDir] = options.baseDir || process.cwd();
    this[_errorStream] = options.errorStream || process.stderr;
    this[_outputStream] = options.outputStream || process.stdout;
    this[_command] = new Command()
      .version(provider.getVersion())
      .usage('[options] [files...]');

    const format = provider.getFormat();

    this[_applyOptions]([
      {
        flags: '--no-color',
        description: 'disables color output'
      },
      {
        flags: '--background <color>',
        description: 'specify background color for transparent regions in SVG'
      },
      {
        flags: '--base-url <url>',
        description: 'specify base URL to use for all relative URLs in SVG'
      },
      {
        flags: '--filename <filename>',
        description: `specify filename for the ${format} output when processing STDIN`
      },
      {
        flags: '--height <value>',
        description: `specify height for ${format}`
      },
      {
        flags: '--puppeteer <json>',
        description: 'specify a json object for puppeteer.launch options',
        transformer: JSON.parse
      },
      {
        flags: '--scale <value>',
        description: 'specify scale to apply to dimensions [1]',
        transformer: parseInt
      },
      {
        flags: '--width <value>',
        description: `specify width for ${format}`
      }
    ]);
    this[_applyOptions](provider.getCLIOptions());
  }

  /**
   * Writes the specified <code>message</code> to the error stream for this {@link CLI}.
   *
   * @param {string} message - the message to be written to the error stream
   * @return {void}
   * @public
   */
  error(message) {
    this[_errorStream].write(`${message}${EOL}`);
  }

  /**
   * Writes the specified <code>message</code> to the output stream for this {@link CLI}.
   *
   * @param {string} message - the message to be written to the output stream
   * @return {void}
   * @public
   */
  output(message) {
    this[_outputStream].write(`${message}${EOL}`);
  }

  /**
   * Parses the command-line (process) arguments provided and performs the necessary actions based on the parsed input.
   *
   * An error will occur if any problem arises.
   *
   * @param {string[]} [args] - the arguments to be parsed
   * @return {Promise.<void, Error>} A <code>Promise</code> that is resolved once all actions have been completed.
   * @public
   */
  async parse(args = []) {
    const command = this[_command].parse(args);
    const options = this[_parseOptions]();

    const converter = new Converter(this[_provider], pick(options, 'puppeteer'));

    try {
      if (command.args.length) {
        const filePaths = [];

        for (const arg of command.args) {
          const files = await findFiles(arg, {
            absolute: true,
            cwd: this[_baseDir],
            nodir: true
          });

          filePaths.push(...files);
        }

        await this[_convertFiles](converter, filePaths, omit(options, 'puppeteer'));
      } else {
        const input = await getStdin();

        await this[_convertInput](converter, input, omit(options, 'puppeteer'),
          command.filename ? path.resolve(this[_baseDir], command.filename) : null);
      }
    } finally {
      await converter.destroy();
    }
  }

  [_applyOptions](options) {
    if (!options) {
      return;
    }

    for (const option of options) {
      this[_command].option(option.flags, option.description, option.transformer);
    }
  }

  async [_convertFiles](converter, filePaths, options) {
    const format = this[_provider].getFormat();

    for (const inputFilePath of filePaths) {
      const outputFilePath = await converter.convertFile(inputFilePath, options);

      this.output(`Converted SVG file to ${format} file: ` +
       `${chalk.blue(inputFilePath)} -> ${chalk.blue(outputFilePath)}`);
    }

    this.output(chalk.green('Done!'));
  }

  async [_convertInput](converter, input, options, filePath) {
    if (!options.baseUrl) {
      options.baseFile = this[_baseDir];
    }

    const output = await converter.convert(input, options);

    if (filePath) {
      await writeFile(filePath, output);

      this.output(`Converted SVG input to ${this[_provider].getFormat()} file: ${chalk.blue(filePath)}`);
      this.output(chalk.green('Done!'));
    } else {
      this[_outputStream].write(output);
    }
  }

  [_parseOptions]() {
    const command = this[_command];
    const options = {
      background: command.background,
      baseUrl: command.baseUrl,
      height: command.height,
      puppeteer: command.puppeteer,
      scale: command.scale,
      width: command.width
    };

    this[_provider].parseCLIOptions(options, command);

    return options;
  }

  /**
   * Returns the {@link Provider} for this {@link CLI}.
   *
   * @return {Provider} The provider.
   * @public
   */
  get provider() {
    return this[_provider];
  }

}

module.exports = CLI;

/**
 * Describes a CLI option.
 *
 * @typedef {Object} CLI~Option
 * @property {string} description - The description to be used when displaying help information for this option.
 * @property {string} flags - The flags to be accepted by this option.
 * @property {Function} [transformer] - The function to be used to transform the argument of this option, where
 * applicable. When omitted, the argument string value will be used as-is.
 */

/**
 * The options that can be passed to the {@link CLI} constructor.
 *
 * @typedef {Object} CLI~Options
 * @property {string} [baseDir=process.cwd()] - The base directory to be used.
 * @property {Writable} [errorStream=process.stderr] - The stream for error messages to be written to.
 * @property {Writable} [outputStream=process.stdout] - The stream for output messages to be written to.
 */
