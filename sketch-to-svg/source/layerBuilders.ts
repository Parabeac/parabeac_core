// Contains all the builders which convert from a Sketch layer to a Paper Item (or not)
import paper from 'paper'
import conversions from './conversions'
import fs from 'fs'
import { SketchFile, Options } from './index'

/** All builders exported from this method will conform to this interface
 * 
 * @param scope The paper scope to build into
 * @param layer The sketch.Layer to convert into a paper.Item
 * @param sketch The Sketch file this builder can fetch resources from, if needed
 * @param options The options this library was created with - this might affect the built options
 * @returns `undefined` if this builder could not create an Item from this layer, or the created item
 */
interface BuilderFunc {
    (scope: paper.PaperScope, layer: any /* sketch.Layer */, sketch?: SketchFile, options?: Options): Promise<paper.Item | undefined>
}

/**
 * Layers which can be represented as a rect will be converted by this builder.
 * 
 * @param layer The layer to convert
 * @returns The created Item (or `null` if it could not be represented as a Paper Rectangle)
 */
let rectangleBuilder: BuilderFunc = async function (scope, layer: any /* sketch.Layer */) {
    if (layer._class != "rectangle") { return }

    let bounds = new scope.Rectangle(0, 0, layer.frame.width, layer.frame.height)
    return new scope.Shape.Rectangle(bounds, layer.fixedRadius);
}

let ellipseBuilder: BuilderFunc = async function (scope, layer: any) {
    if (layer._class != "oval") { return }

    let bounds = new scope.Rectangle(0, 0, layer.frame.width, layer.frame.height)
    let ellipse = new scope.Shape.Ellipse(bounds)

    return ellipse
}

let fillBuilder: BuilderFunc = async function (scope, layer, sketch) {
    if (layer._class != "shapeGroup") { return }

    // Create all the subpaths - we can't use map beacuse the await inside it won't compile.
    let paths: any[] = []

    for (let index = 0; index < layer.layers.length; ++index) {
        let child = layer.layers[index]

        // OK, we might need to recurse here - a shapeGroup can contain other shapeGroups.
        let item: any | null
        if (child._class == "shapeGroup") {
            item = await fillBuilder(scope, child, sketch)
        } else {
            item = layerPointsToPath(scope, child)
        }

        paths.push({
            layer: child,
            path: item
        })
    }

    paths = paths
        .filter((element: any /* [ layer: Layer, path: Path ] */) => {
            return element.path ? true : false
        })
        .map((element: any /* [ layer: Layer, path: Path ] */) => {
            if (!element.path.translate) {
                console.log(element, element.path)
            }
            return {
                layer: element.layer,
                path: element.path.translate([element.layer.frame.x, element.layer.frame.y])
            }
        })

    // Now, we combine the paths together using their layer's booleanOperation
    let firstPath = paths.shift()
    let maskPath = paths.reduce((acc: any /* Path */, elem: any /* Path */) => {
        switch (elem.layer.booleanOperation) {
            case 0: return acc.unite(elem.path, { insert: false })
            case 1: return acc.subtract(elem.path, { insert: false })
            case 2: return acc.intersect(elem.path, { insert: false })
            case -1:
            case 3: return acc.exclude(elem.path, { insert: false })
            default: return acc
        }
    }, firstPath.path)

    return maskPath
}

let pathBuilder: BuilderFunc = async function (scope, layer) {
    if (!Array.isArray(layer.points) || layer.points.length == 0) { return }

    return layerPointsToPath(scope, layer)
}

let bitmapBuilder: BuilderFunc = async function (scope, layer, sketch, options) {
    if (layer._class != "bitmap") { return }
    if (!sketch) { return }

    // TODO: There's lots of nesting here because of image.onload - though this has probably been solved. Refactor when we have time.
    return new Promise((resolve, reject) => {

        sketch.contentsPath()
            .then(contentsPath => {

                let path = contentsPath + "/" + layer.image._ref
                let data = fs.readFileSync(path, { flag: 'r' })
                let image = new scope.Raster("data:image/png;base64," + Buffer.from(data).toString('base64'))

                image.onLoad = function () {
                    image.size = new scope.Size(layer.frame.width, layer.frame.height)
                    image.position = new scope.Point(layer.frame.x + layer.frame.width / 2, layer.frame.y + layer.frame.height / 2)

                    // If we don't want to optimize the image, just resolve the promise now
                    if (!options || !options.optimizeImageSize) {
                        resolve(image)
                        return
                    }

                    import('sharp')
                        .then(sharp => {
                            let scale = options.optimizeImageSizeFactor || 3
                            let width = Math.ceil(layer.frame.width) * scale
                            let height = Math.ceil(layer.frame.height) * scale
                            let resizeOptions = { fit: sharp.fit.fill, withoutEnlargement: true }
                            return sharp.default(data).resize(width, height, resizeOptions).png().toBuffer()
                        })
                        .then(result => {
                            // Remove the previous image element and add one with the smaller data set
                            image.remove()

                            // We can't just set the data uri again (sigh) so we'll create a new one
                            let sizedImage = new scope.Raster(`data:image/png;base64,${result.toString('base64')}`)
                            sizedImage.onLoad = function () {
                                sizedImage.size = image.size
                                sizedImage.position = image.position
                                resolve(sizedImage)
                            }
                        })
                        .catch(err => {
                            console.log("Failed to scale image", err)
                            resolve(image)
                        })
                }
            })
            .catch(err => { reject(err) })
    })
}

/**
 * Convert a layer's points to a paper Path object.
 * 
 * NB: The path isn't attached to any layers / groups.
 * 
 * @param {paper.PaperScope} scope The paper instance to work within
 * @param {sketch.Layer} layer The layer whose points will be converted to a paper.Path
 * @returns {paper.Path} A `Path` created from the points in the layer.
 */
function layerPointsToPath(scope: paper.PaperScope, layer: any /* sketch.Layer */): paper.Path | undefined {
    if (!Array.isArray(layer.points)) { return }

    let scale = new scope.Point(layer.frame.width, layer.frame.height)

    let segments = layer.points.map((point: any): paper.Segment | undefined => {
        // Parse the input, annoyingly they are strings.

        // The origin is required - you can't have a segment without a point
        let rawOrigin = conversions.pointFromSketchString(scope, point.point)
        if (!rawOrigin) { return }

        // The control points might not be needed for all segments, so don't bail if they aren't there.
        let rawCurveFrom = conversions.pointFromSketchString(scope, point.curveFrom)
        let rawCurveTo = conversions.pointFromSketchString(scope, point.curveTo)

        let origin = rawOrigin.multiply(scale)
        let curveFrom = point.hasCurveFrom && rawCurveFrom ? rawCurveFrom.multiply(scale).subtract(origin) : undefined
        let curveTo = point.hasCurveTo && rawCurveTo ? rawCurveTo.multiply(scale).subtract(origin) : undefined
        return new scope.Segment(origin, curveTo, curveFrom)
    })

    let path = new scope.Path(segments)

    path.visible = layer.isVisible
    path.closed = layer.isClosed

    path.remove()

    return path
}

export default { rect: rectangleBuilder, ellipse: ellipseBuilder, fill: fillBuilder, path: pathBuilder, bitmap: bitmapBuilder }
