/// <reference types="node" />
/**
 * Represents the contents of an svg document and any external assets which need to bundled along with it.
 *
 * Paths to the assets are relative to the location you put the svg.
 */
export declare class SVG {
    /**
     * The contents of the svg document (xml as string, utf8)
     */
    readonly svg: string;
    /**
     * External images referenced by the svg file
     */
    readonly images: Asset[];
    constructor(svg: string, images?: Asset[]);
}
/**
 * An asset which makes part of an SVG. Store the contents of the contents buffer at the path specified.
 */
export declare class Asset {
    readonly path: string;
    readonly contents: Buffer;
    constructor(path: string, contents: Buffer);
}
/**
 * Helper class to extract assets from a sketch file at the given filepath
 *
 * @param sketchFilePath Path to the original Sketch file - used to extract things like image data
 * @param optimizeImageSize Should images exported be optimized to the size in the svg, or just dumped out directly as found in the Sketch file?
 * @param optimizeImageSizeFactor The higher the number, the better the optimized image quality.
 */
export declare type Options = {
    sketchFilePath?: string;
    optimizeImageSize?: boolean;
    optimizeImageSizeFactor?: number;
};
export declare class SketchFile {
    private filepath;
    private id;
    contentsPath(): Promise<string>;
    constructor(filepath: string);
    /**
     * Helpful constructor method which can cope with the filepath being undefined (it just returns undefined in that case)
     *
     * @param filepath The path to the file
     */
    static from(filepath: string | undefined): SketchFile | undefined;
}
/**
 * Given a layer from a Sketch file, returns a string containing the contents of an svg file
 */
export declare function createFromLayer(layer: any, options?: Options): Promise<SVG>;
