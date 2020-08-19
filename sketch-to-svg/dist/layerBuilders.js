"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    Object.defineProperty(o, k2, { enumerable: true, get: function() { return m[k]; } });
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __generator = (this && this.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (_) try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
var conversions_1 = __importDefault(require("./conversions"));
var fs_1 = __importDefault(require("fs"));
/**
 * Layers which can be represented as a rect will be converted by this builder.
 *
 * @param layer The layer to convert
 * @returns The created Item (or `null` if it could not be represented as a Paper Rectangle)
 */
var rectangleBuilder = function (scope, layer /* sketch.Layer */) {
    return __awaiter(this, void 0, void 0, function () {
        var bounds;
        return __generator(this, function (_a) {
            if (layer._class != "rectangle") {
                return [2 /*return*/];
            }
            bounds = new scope.Rectangle(0, 0, layer.frame.width, layer.frame.height);
            return [2 /*return*/, new scope.Shape.Rectangle(bounds, layer.fixedRadius)];
        });
    });
};
var ellipseBuilder = function (scope, layer) {
    return __awaiter(this, void 0, void 0, function () {
        var bounds, ellipse;
        return __generator(this, function (_a) {
            if (layer._class != "oval") {
                return [2 /*return*/];
            }
            bounds = new scope.Rectangle(0, 0, layer.frame.width, layer.frame.height);
            ellipse = new scope.Shape.Ellipse(bounds);
            return [2 /*return*/, ellipse];
        });
    });
};
var fillBuilder = function (scope, layer, sketch) {
    return __awaiter(this, void 0, void 0, function () {
        var paths, index, child, item, firstPath, maskPath;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0:
                    if (layer._class != "shapeGroup") {
                        return [2 /*return*/];
                    }
                    paths = [];
                    index = 0;
                    _a.label = 1;
                case 1:
                    if (!(index < layer.layers.length)) return [3 /*break*/, 6];
                    child = layer.layers[index];
                    item = void 0;
                    if (!(child._class == "shapeGroup")) return [3 /*break*/, 3];
                    return [4 /*yield*/, fillBuilder(scope, child, sketch)];
                case 2:
                    item = _a.sent();
                    return [3 /*break*/, 4];
                case 3:
                    item = layerPointsToPath(scope, child);
                    _a.label = 4;
                case 4:
                    paths.push({
                        layer: child,
                        path: item
                    });
                    _a.label = 5;
                case 5:
                    ++index;
                    return [3 /*break*/, 1];
                case 6:
                    paths = paths
                        .filter(function (element /* [ layer: Layer, path: Path ] */) {
                        return element.path ? true : false;
                    })
                        .map(function (element /* [ layer: Layer, path: Path ] */) {
                        if (!element.path.translate) {
                            console.log(element, element.path);
                        }
                        return {
                            layer: element.layer,
                            path: element.path.translate([element.layer.frame.x, element.layer.frame.y])
                        };
                    });
                    firstPath = paths.shift();
                    maskPath = paths.reduce(function (acc /* Path */, elem /* Path */) {
                        switch (elem.layer.booleanOperation) {
                            case 0: return acc.unite(elem.path, { insert: false });
                            case 1: return acc.subtract(elem.path, { insert: false });
                            case 2: return acc.intersect(elem.path, { insert: false });
                            case -1:
                            case 3: return acc.exclude(elem.path, { insert: false });
                            default: return acc;
                        }
                    }, firstPath.path);
                    return [2 /*return*/, maskPath];
            }
        });
    });
};
var pathBuilder = function (scope, layer) {
    return __awaiter(this, void 0, void 0, function () {
        return __generator(this, function (_a) {
            if (!Array.isArray(layer.points) || layer.points.length == 0) {
                return [2 /*return*/];
            }
            return [2 /*return*/, layerPointsToPath(scope, layer)];
        });
    });
};
var bitmapBuilder = function (scope, layer, sketch, options) {
    return __awaiter(this, void 0, void 0, function () {
        return __generator(this, function (_a) {
            if (layer._class != "bitmap") {
                return [2 /*return*/];
            }
            if (!sketch) {
                return [2 /*return*/];
            }
            // TODO: There's lots of nesting here because of image.onload - though this has probably been solved. Refactor when we have time.
            return [2 /*return*/, new Promise(function (resolve, reject) {
                    sketch.contentsPath()
                        .then(function (contentsPath) {
                        var path = contentsPath + "/" + layer.image._ref;
                        var data = fs_1.default.readFileSync(path, { flag: 'r' });
                        var image = new scope.Raster("data:image/png;base64," + Buffer.from(data).toString('base64'));
                        image.onLoad = function () {
                            image.size = new scope.Size(layer.frame.width, layer.frame.height);
                            image.position = new scope.Point(layer.frame.x + layer.frame.width / 2, layer.frame.y + layer.frame.height / 2);
                            // If we don't want to optimize the image, just resolve the promise now
                            if (!options || !options.optimizeImageSize) {
                                resolve(image);
                                return;
                            }
                            Promise.resolve().then(function () { return __importStar(require('sharp')); }).then(function (sharp) {
                                var scale = options.optimizeImageSizeFactor || 3;
                                var width = Math.ceil(layer.frame.width) * scale;
                                var height = Math.ceil(layer.frame.height) * scale;
                                var resizeOptions = { fit: sharp.fit.fill, withoutEnlargement: true };
                                return sharp.default(data).resize(width, height, resizeOptions).png().toBuffer();
                            })
                                .then(function (result) {
                                // Remove the previous image element and add one with the smaller data set
                                image.remove();
                                // We can't just set the data uri again (sigh) so we'll create a new one
                                var sizedImage = new scope.Raster("data:image/png;base64," + result.toString('base64'));
                                sizedImage.onLoad = function () {
                                    sizedImage.size = image.size;
                                    sizedImage.position = image.position;
                                    resolve(sizedImage);
                                };
                            })
                                .catch(function (err) {
                                console.log("Failed to scale image", err);
                                resolve(image);
                            });
                        };
                    })
                        .catch(function (err) { reject(err); });
                })];
        });
    });
};
/**
 * Convert a layer's points to a paper Path object.
 *
 * NB: The path isn't attached to any layers / groups.
 *
 * @param {paper.PaperScope} scope The paper instance to work within
 * @param {sketch.Layer} layer The layer whose points will be converted to a paper.Path
 * @returns {paper.Path} A `Path` created from the points in the layer.
 */
function layerPointsToPath(scope, layer /* sketch.Layer */) {
    if (!Array.isArray(layer.points)) {
        return;
    }
    var scale = new scope.Point(layer.frame.width, layer.frame.height);
    var segments = layer.points.map(function (point) {
        // Parse the input, annoyingly they are strings.
        // The origin is required - you can't have a segment without a point
        var rawOrigin = conversions_1.default.pointFromSketchString(scope, point.point);
        if (!rawOrigin) {
            return;
        }
        // The control points might not be needed for all segments, so don't bail if they aren't there.
        var rawCurveFrom = conversions_1.default.pointFromSketchString(scope, point.curveFrom);
        var rawCurveTo = conversions_1.default.pointFromSketchString(scope, point.curveTo);
        var origin = rawOrigin.multiply(scale);
        var curveFrom = point.hasCurveFrom && rawCurveFrom ? rawCurveFrom.multiply(scale).subtract(origin) : undefined;
        var curveTo = point.hasCurveTo && rawCurveTo ? rawCurveTo.multiply(scale).subtract(origin) : undefined;
        return new scope.Segment(origin, curveTo, curveFrom);
    });
    var path = new scope.Path(segments);
    path.visible = layer.isVisible;
    path.closed = layer.isClosed;
    path.remove();
    return path;
}
exports.default = { rect: rectangleBuilder, ellipse: ellipseBuilder, fill: fillBuilder, path: pathBuilder, bitmap: bitmapBuilder };
