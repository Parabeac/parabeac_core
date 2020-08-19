#! /usr/bin/env node
const fs = require('fs');
const { Sketch } = require('sketch-constructor')
const svg = require('./dist/index.js')
const formatter = require('xml-formatter')

// Enumerate the test files folder, and deal with every sketch file we find in there.
let extension = ".sketch"
let path = `${process.cwd()}` + "/__tests__/__sketch-files/"
fs.readdirSync(path)
    .filter(filename => { return filename.endsWith(extension) })
    .map(filename => { return filename.substring(0, filename.length-extension.length) })
    .forEach(file => {
        let absolutePath = path + file + extension
        Sketch
            .fromFile(absolutePath)
            .then(sketch => {
                let layers = sketch.pages
                    .flatMap(page => { return page.getLayers() })
                //.filter((element) => { return element.name == "Search" })

                console.log(`Found ${layers.length} layers to render from ${file}`)
                console.log(`  Outputting to ./out/${file}`)

                return layers
            })
            .then(layers => {
                let options = { sketchFilePath: absolutePath, optimizeImageSize: true, optimizeImageSizeFactor: 1 }

                layers.forEach(layer => {

                    svg.createFromLayer(layer, options)
                        .then(icon => {

                            console.log(`---------- Completed ${layer.name}`)

                            if (0) {
                                console.log(formatter(icon.svg))
                                if (icon.images.length > 0) {
                                    console.log(`and ${icon.images.length} assets: ${icon.images.map(asset => { return asset.path; })}`)
                                }
                                console.log("----------\n")
                            }

                            // For each layer, create the folder and then write the svg out to a file
                            let filename = `out/${file}/${layer.name}.svg`

                            // For each path component
                            let folder = filename.split('/').slice(0, -1).join('/')
                            fs.mkdirSync(folder, { recursive: true })

                            fs.writeFile(filename, icon.svg, err => {
                                if (err) {
                                    console.log(`Error saving ${filename}: ${err}`)
                                }
                            })

                            // And store the assets
                            icon.images.forEach(image => {
                                let imagePath = folder + "/" + image.path
                                let imageFolder = imagePath.split('/').slice(0, -1).join('/')
                                fs.mkdirSync(imageFolder, { recursive: true })

                                fs.writeFile(imagePath, image.contents, err => {
                                    if (err) {
                                        console.log(`Error saving image ${image.path}: ${err}`)
                                    }
                                })
                            })
                        }).catch((err) => {
                            console.log(err)
                        })
                })
            })
    })
