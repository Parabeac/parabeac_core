const { convert } = require("./convert-svg/packages/convert-svg-to-png/src/index.js");

const { Sketch } = require("sketch-constructor");

const svg = require("./dist/index.js");

// const SvgToImg = require('@ycm.jason/svg-to-img');
// const svgToImg = SvgToImg();

const fs = require("fs");

let options = { optimizeImageSize: true, optimizeImageSizeFactor: 3 };

/**
 * This program converts a sketch JSON layer to PNG and outputs the file.
 * When calling the program:
 *  The first argument is the JSON Sketch layer to convert to png.
 *  The second argument is the output directory where the file will go.
 *  The third argument is the name of the file to be output.
 */
module.exports = {
  convert: async function (json) {
    try {
      const icon = await svg.createFromLayer(json, options);

      // Convert the svg to png
      const png = await convert(icon.svg, {
        puppeteer: {
          args: ["--no-sandbox", "--disable-setuid-sandbox"],
        },
      });
      // const png = await svgToImg.png(icon)

      return png;
    } catch (err) {
      console.log("Failed to create png:", err);
    }
  },
};
