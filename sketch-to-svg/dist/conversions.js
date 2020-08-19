"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.convertLineJoinStyle = exports.convertLineCapStyle = exports.arrayFromSketchString = exports.pointFromSketchString = void 0;
/**
 * Takes in a string in the form "{123, 456}" and returns a `paper.Point`
 */
function pointFromSketchString(scope, value) {
    var values = arrayFromSketchString(value);
    if (!values) {
        return;
    }
    if (values.length < 2) {
        return;
    }
    return new scope.Point(values[0], values[1]);
}
exports.pointFromSketchString = pointFromSketchString;
/** Converts a string in the form {1,2} into an array of numbers i.e. [1, 2]
 *
 * @param value The string to parse
 */
function arrayFromSketchString(value) {
    // Sanity
    value = value.trim();
    if (value.length < 2) {
        return;
    }
    if (value[0] != "{" || value[value.length - 1] != "}") {
        return;
    }
    // Trim the surrounding { } and remove the whitespace in the string
    var points = value
        .substring(1, value.length - 1)
        .replace(' ', '');
    // If there aren't any points at all, return an empty array
    if (points.length == 0) {
        return [];
    }
    // Map each point to a float and return the array of values
    return points
        .split(",")
        .map(function (value) { return parseFloat(value); });
}
exports.arrayFromSketchString = arrayFromSketchString;
// Converts the line cap style integer to the svg name
function convertLineCapStyle(intValue) {
    return ["butt", "round", "square"][intValue] || undefined;
}
exports.convertLineCapStyle = convertLineCapStyle;
function convertLineJoinStyle(intValue) {
    return ["miter", "round", "bevel"][intValue] || undefined;
}
exports.convertLineJoinStyle = convertLineJoinStyle;
exports.default = {
    pointFromSketchString: pointFromSketchString,
    convertLineCapStyle: convertLineCapStyle,
    convertLineJoinStyle: convertLineJoinStyle
};
