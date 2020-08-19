import paper from 'paper';
/**
 * Takes in a string in the form "{123, 456}" and returns a `paper.Point`
 */
export declare function pointFromSketchString(scope: paper.PaperScope, value: string): paper.Point | undefined;
/** Converts a string in the form {1,2} into an array of numbers i.e. [1, 2]
 *
 * @param value The string to parse
 */
export declare function arrayFromSketchString(value: string): number[] | undefined;
export declare function convertLineCapStyle(intValue: number): string | undefined;
export declare function convertLineJoinStyle(intValue: number): string | undefined;
declare const _default: {
    pointFromSketchString: typeof pointFromSketchString;
    convertLineCapStyle: typeof convertLineCapStyle;
    convertLineJoinStyle: typeof convertLineJoinStyle;
};
export default _default;
