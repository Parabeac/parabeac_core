"use strict";
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
exports.createFromLayer = exports.SketchFile = exports.Asset = exports.SVG = void 0;
var paper_1 = __importDefault(require("paper"));
var conversions_1 = __importDefault(require("./conversions"));
var layerBuilders_1 = __importDefault(require("./layerBuilders"));
var v4_1 = __importDefault(require("uuid/v4"));
var fs_1 = __importDefault(require("fs"));
var extract_zip_1 = __importDefault(require("extract-zip"));
var os_1 = __importDefault(require("os"));
/**
 * Represents the contents of an svg document and any external assets which need to bundled along with it.
 *
 * Paths to the assets are relative to the location you put the svg.
 */
var SVG = /** @class */ (function () {
    function SVG(svg, images) {
        this.svg = svg;
        this.images = images || [];
    }
    return SVG;
}());
exports.SVG = SVG;
/**
 * An asset which makes part of an SVG. Store the contents of the contents buffer at the path specified.
 */
var Asset = /** @class */ (function () {
    function Asset(path, contents) {
        this.path = path;
        this.contents = contents;
    }
    return Asset;
}());
exports.Asset = Asset;
/**
 *  The order we try to convert a layer to a Paper.Item is important.
 */
var builders = [layerBuilders_1.default.bitmap, layerBuilders_1.default.rect, layerBuilders_1.default.ellipse, layerBuilders_1.default.fill, layerBuilders_1.default.path];
var SketchFile = /** @class */ (function () {
    function SketchFile(filepath) {
        this.id = v4_1.default();
        this.filepath = filepath;
    }
    SketchFile.prototype.contentsPath = function () {
        var sourcePath = this.filepath;
        var path = os_1.default.tmpdir() + "/sketch-to-svg/" + this.id;
        // If we have already unzipped, just return the path
        if (fs_1.default.existsSync(path)) {
            return Promise.resolve(path);
        }
        return new Promise(function (resolve, reject) {
            // Unzip the file to that folder
            extract_zip_1.default(sourcePath, { dir: path }, function (error) {
                if (error) {
                    console.log("WARNING: Failed to extract Sketch file contents from " + sourcePath + " to " + path);
                    console.log(error);
                    fs_1.default.unlinkSync(path);
                    reject(error);
                }
                else {
                    resolve(path);
                }
            });
        });
    };
    /**
     * Helpful constructor method which can cope with the filepath being undefined (it just returns undefined in that case)
     *
     * @param filepath The path to the file
     */
    SketchFile.from = function (filepath) {
        if (!filepath) {
            return undefined;
        }
        return new SketchFile(filepath);
    };
    return SketchFile;
}());
exports.SketchFile = SketchFile;
/**
 * Given a layer from a Sketch file, returns a string containing the contents of an svg file
 */
function createFromLayer(layer /* sketch.Layer */, options) {
    return __awaiter(this, void 0, void 0, function () {
        var scope, svg;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0:
                    scope = new paper_1.default.PaperScope();
                    // Create the paper context
                    scope.setup(new scope.Size(layer.frame.width, layer.frame.height));
                    // Sanity, mostly just to make typescript happy.
                    if (!scope.project) {
                        throw "Default paper.js project not created automatically by paper.js. Check their issuelog!";
                    }
                    // Recurse through the tree of layers
                    return [4 /*yield*/, renderLayer(scope, layer, scope.project.activeLayer, options)];
                case 1:
                    // Recurse through the tree of layers
                    _a.sent();
                    svg = scope.project.exportSVG({ asString: true, precision: 2, pretty: true }).toString();
                    return [2 /*return*/, new SVG(svg.toString(), [])];
            }
        });
    });
}
exports.createFromLayer = createFromLayer;
// Private methods
function renderLayer(scope, layer /* sketch.Layer */, group /* sketch.Group */, options) {
    if (options === void 0) { options = {}; }
    return __awaiter(this, void 0, void 0, function () {
        var sketchfile, item, _i, builders_1, builder, children, clippingGroup, childIndex, layer_1, newGroup, createdItem, mask, scaleX, scaleY;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0:
                    if (!layer.isVisible) {
                        return [2 /*return*/];
                    }
                    sketchfile = SketchFile.from(options.sketchFilePath);
                    _i = 0, builders_1 = builders;
                    _a.label = 1;
                case 1:
                    if (!(_i < builders_1.length)) return [3 /*break*/, 4];
                    builder = builders_1[_i];
                    return [4 /*yield*/, builder(scope, layer, sketchfile, options)];
                case 2:
                    item = _a.sent();
                    if (item) {
                        if (!item.name) {
                            item.name = layer.name;
                        }
                        styleItem(scope, layer.style, item);
                        group.addChild(item);
                        return [3 /*break*/, 4];
                    }
                    _a.label = 3;
                case 3:
                    _i++;
                    return [3 /*break*/, 1];
                case 4:
                    if (!!item) return [3 /*break*/, 8];
                    children = layer.layers;
                    clippingGroup = void 0;
                    if (!Array.isArray(children)) return [3 /*break*/, 8];
                    childIndex = 0;
                    _a.label = 5;
                case 5:
                    if (!(childIndex < children.length)) return [3 /*break*/, 8];
                    layer_1 = children[childIndex];
                    newGroup = new scope.Group();
                    group.addChild(newGroup);
                    newGroup.name = "Group: " + layer_1.name;
                    return [4 /*yield*/, renderLayer(scope, layer_1, newGroup, options)
                        // If the createdItem breaks the clipping group, remove the clipping group we are tracking
                    ];
                case 6:
                    createdItem = _a.sent();
                    // If the createdItem breaks the clipping group, remove the clipping group we are tracking
                    if (layer_1.shouldBreakMaskChain) {
                        clippingGroup = undefined;
                    }
                    // If the created item creates a clipping mask, create a clipping group to use
                    if (createdItem && layer_1.hasClippingMask) {
                        mask = createdItem.clone();
                        mask.name = createdItem.name + " (as mask)";
                        // Create (and store) the clipping group with the mask sets
                        clippingGroup = new scope.Group([mask]);
                        if (clippingGroup) {
                            clippingGroup.name = layer_1.name + " (Mask Group)";
                            clippingGroup.clipped = true;
                            group.addChild(clippingGroup);
                        }
                    }
                    // If we have a clipping group, make sure the createdItem's group is inside it
                    if (clippingGroup) {
                        clippingGroup.addChild(newGroup);
                    }
                    // Now, move / scale etc the group - this will update it's children
                    // Move to this layer's position
                    newGroup.translate(new scope.Point(layer_1.frame.x, layer_1.frame.y));
                    // Flip if needed
                    if (layer_1.isFlippedHorizontal || layer_1.isFlippedVertical) {
                        scaleX = layer_1.isFlippedHorizontal ? -1 : 1;
                        scaleY = layer_1.isFlippedVertical ? -1 : 1;
                        newGroup.scale(scaleX, scaleY);
                    }
                    // Rotate if needed
                    if (layer_1.rotation) {
                        newGroup.rotate(layer_1.rotation);
                    }
                    // Set the opacity
                    newGroup.opacity = layer_1.style.contextSettings.opacity;
                    _a.label = 7;
                case 7:
                    ++childIndex;
                    return [3 /*break*/, 5];
                case 8: 
                // Return the created item
                return [2 /*return*/, item];
            }
        });
    });
}
/**
 *  Applies a Sketch style to a paper.Item instance
 */
function styleItem(scope, style /* sketch.Style */, item) {
    var border = style.borders.find(function (element) { return element.isEnabled; });
    if (border != undefined) {
        item.strokeColor = new scope.Color(border.color.red, border.color.green, border.color.blue, border.color.alpha);
        item.strokeWidth = border.thickness;
    }
    var fill = style.fills.find(function (element) { return element.isEnabled; });
    if (fill != undefined) {
        item.fillColor = new scope.Color(fill.color.red, fill.color.green, fill.color.blue, fill.color.alpha);
    }
    item.strokeCap = conversions_1.default.convertLineCapStyle(style.borderOptions.lineCapStyle) || null;
    item.strokeJoin = conversions_1.default.convertLineJoinStyle(style.borderOptions.lineJoinStyle) || null;
}
