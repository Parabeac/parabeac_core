import paper from 'paper'
import conversions from './conversions'
import layerBuilders from './layerBuilders'
import uuid from 'uuid/v4'
import fs from 'fs'
import extract from 'extract-zip'
import os from 'os'

/**
 * Represents the contents of an svg document and any external assets which need to bundled along with it.
 * 
 * Paths to the assets are relative to the location you put the svg.
 */
export class SVG {
    /**
     * The contents of the svg document (xml as string, utf8)
     */
    readonly svg: string
  
    /**
     * External images referenced by the svg file
     */
    readonly images: Asset[]
  
    constructor(svg: string, images?: Asset[]) {
      this.svg = svg
      this.images = images || []
    }
}

/**
 * An asset which makes part of an SVG. Store the contents of the contents buffer at the path specified.
 */
export class Asset {
    readonly path: string
    readonly contents: Buffer

    constructor(path: string, contents: Buffer) {
        this.path = path
        this.contents = contents
    }
}

/**
 *  The order we try to convert a layer to a Paper.Item is important.
 */
const builders = [layerBuilders.bitmap, layerBuilders.rect, layerBuilders.ellipse, layerBuilders.fill, layerBuilders.path]

/**
 * Helper class to extract assets from a sketch file at the given filepath
 * 
 * @param sketchFilePath Path to the original Sketch file - used to extract things like image data
 * @param optimizeImageSize Should images exported be optimized to the size in the svg, or just dumped out directly as found in the Sketch file?
 * @param optimizeImageSizeFactor The higher the number, the better the optimized image quality.
 */
export type Options = {
    sketchFilePath?: string,
    optimizeImageSize?: boolean,
    optimizeImageSizeFactor?: number
}

export class SketchFile {
    private filepath: string
    private id: string = uuid()

    contentsPath(): Promise<string> {
        let sourcePath = this.filepath
        let path = `${os.tmpdir()}/sketch-to-svg/${this.id}`

        // If we have already unzipped, just return the path
        if (fs.existsSync(path)) { return Promise.resolve(path) }

        return new Promise((resolve, reject) => {
            // Unzip the file to that folder
            extract(sourcePath, { dir: path }, function (error: any) {
                if (error) {
                    console.log(`WARNING: Failed to extract Sketch file contents from ${sourcePath} to ${path}`)
                    console.log(error)
                    fs.unlinkSync(path)
                    reject(error)
                } else {
                    resolve(path)
                }
            })
        })
    }

    constructor(filepath: string) {
        this.filepath = filepath
    }

    /**
     * Helpful constructor method which can cope with the filepath being undefined (it just returns undefined in that case)
     * 
     * @param filepath The path to the file
     */
    static from(filepath: string | undefined): SketchFile | undefined {
        if (!filepath) { return undefined }
        return new SketchFile(filepath)
    }
}

/**
 * Given a layer from a Sketch file, returns a string containing the contents of an svg file
 */
export async function createFromLayer(layer: any /* sketch.Layer */, options?: Options): Promise<SVG> {

    let scope = new paper.PaperScope()

    // Create the paper context
    scope.setup(new scope.Size(layer.frame.width, layer.frame.height))

    // Sanity, mostly just to make typescript happy.
    if (!scope.project) {
        throw "Default paper.js project not created automatically by paper.js. Check their issuelog!"
    }

    // Recurse through the tree of layers
    await renderLayer(scope, layer, scope.project.activeLayer, options)
    
    let svg = scope.project.exportSVG({ asString: true, precision: 2, pretty: true }).toString()

    return new SVG(svg.toString(), [])
}

// Private methods

async function renderLayer(scope: paper.PaperScope, layer: any /* sketch.Layer */, group: any /* sketch.Group */, options: Options = {}): Promise<paper.Item | undefined> {
    if (!layer.isVisible) { return }

    // Create this to pass into the builder methods
    let sketchfile = SketchFile.from(options.sketchFilePath)

    // Run through all the builders in turn, taking the first successful one
    let item: paper.Item | undefined
    for (let builder of builders) {
        item = await builder(scope, layer, sketchfile, options)

        if (item) {
            if (!item.name) {
                item.name = layer.name
            }
            styleItem(scope, layer.style, item)
            group.addChild(item)
            break
        }
    }

    // Recurse down into it's children if we didn't create anything.
    if (!item) {
        let children = layer.layers

        let clippingGroup: paper.Group | undefined

        if (Array.isArray(children)) {
            for (let childIndex = 0; childIndex < children.length; ++childIndex) {
                let layer = children[childIndex]

                // Create a new group to deal with offsets etc
                let newGroup = new scope.Group()
                group.addChild(newGroup)
                newGroup.name = "Group: " + layer.name

                // Draw it's children into this group
                let createdItem = await renderLayer(scope, layer, newGroup, options)

                // If the createdItem breaks the clipping group, remove the clipping group we are tracking
                if (layer.shouldBreakMaskChain) {
                    clippingGroup = undefined
                }

                // If the created item creates a clipping mask, create a clipping group to use
                if (createdItem && layer.hasClippingMask) {

                    let mask = createdItem.clone()
                    mask.name = createdItem.name + " (as mask)"

                    // Create (and store) the clipping group with the mask sets
                    clippingGroup = new scope.Group([mask])
                    if (clippingGroup) {
                        clippingGroup.name = layer.name + " (Mask Group)"
                        clippingGroup.clipped = true
                        group.addChild(clippingGroup)
                    }
                }

                // If we have a clipping group, make sure the createdItem's group is inside it
                if (clippingGroup) {
                    clippingGroup.addChild(newGroup)
                }

                // Now, move / scale etc the group - this will update it's children

                // Move to this layer's position
                newGroup.translate(new scope.Point(layer.frame.x, layer.frame.y))

                // Flip if needed
                if (layer.isFlippedHorizontal || layer.isFlippedVertical) {
                    let scaleX = layer.isFlippedHorizontal ? -1 : 1
                    let scaleY = layer.isFlippedVertical ? -1 : 1
                    newGroup.scale(scaleX, scaleY)
                }

                // Rotate if needed
                if (layer.rotation) {
                    newGroup.rotate(layer.rotation)
                }

                // Set the opacity
                newGroup.opacity = layer.style.contextSettings.opacity
            }
        }
    }

    // Return the created item
    return item
}

/**
 *  Applies a Sketch style to a paper.Item instance
 */
function styleItem(scope: paper.PaperScope, style: any /* sketch.Style */, item: paper.Item) {
    let border = style.borders.find((element: any) => { return element.isEnabled })
    if (border != undefined) {
        item.strokeColor = new scope.Color(border.color.red, border.color.green, border.color.blue, border.color.alpha)
        item.strokeWidth = border.thickness
    }

    let fill = style.fills.find((element: any) => { return element.isEnabled })
    if (fill != undefined) {
        item.fillColor = new scope.Color(fill.color.red, fill.color.green, fill.color.blue, fill.color.alpha)
    }

    item.strokeCap = conversions.convertLineCapStyle(style.borderOptions.lineCapStyle) || null
    item.strokeJoin = conversions.convertLineJoinStyle(style.borderOptions.lineJoinStyle) || null
}
