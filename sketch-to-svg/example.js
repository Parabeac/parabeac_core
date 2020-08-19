/// At the moment you need to pass in a sketch-constructor layer.
const { Sketch } = require('sketch-constructor')

/// Require the library
// const svg = require('sketch-to-svg')
const svg = require('./dist/index.js')

// Open the sketch file and pass in the layer you want to extract
let absolutePath = `${process.cwd()}` + "/__tests__/__sketch-files/basic-lines.sketch"
Sketch
  .fromFile(absolutePath)
  .then(sketch => {
    /// Get the layer you want to extract - this example extracts the first layer in the first page
    let layer = sketch.getPages()[0].layers[0]

    let options = { sketchFilePath: absolutePath, optimizeImageSize: true, optimizeImageSizeFactor: 3 }

    return svg.createFromLayer(layer, options)
  })
  .then(icon => {
    // For this example, we just dump the svg to the console
    console.log(icon.svg)
  })
  .catch(err => {
    console.log("Failed to create svg:", err)
  })
