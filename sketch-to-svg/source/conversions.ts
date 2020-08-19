import paper from 'paper'
 
/** 
 * Takes in a string in the form "{123, 456}" and returns a `paper.Point`
 */
export function pointFromSketchString(scope: paper.PaperScope, value: string): paper.Point | undefined {
    let values = arrayFromSketchString(value)
    if (!values) { return }
    if (values.length < 2) { return }

    return new scope.Point(values[0], values[1])
}

/** Converts a string in the form {1,2} into an array of numbers i.e. [1, 2]
 * 
 * @param value The string to parse
 */
export function arrayFromSketchString(value: string): number[] | undefined {
    // Sanity
    value = value.trim()
    if (value.length < 2) { return }
    if (value[0] != "{" || value[value.length-1] != "}") { return }

    // Trim the surrounding { } and remove the whitespace in the string
    let points = value
        .substring(1, value.length-1)
        .replace(' ', '')

    // If there aren't any points at all, return an empty array
    if (points.length == 0) { return [] }

    // Map each point to a float and return the array of values
    return points
        .split(",")
        .map((value) => { return parseFloat(value) })
}

// Converts the line cap style integer to the svg name
export function convertLineCapStyle(intValue: number): string | undefined {
    return ["butt", "round", "square"][intValue] || undefined
}

export function convertLineJoinStyle(intValue: number): string | undefined {
    return ["miter", "round", "bevel"][intValue] || undefined
}

export default {
    pointFromSketchString: pointFromSketchString,
    convertLineCapStyle: convertLineCapStyle,
    convertLineJoinStyle: convertLineJoinStyle
}
