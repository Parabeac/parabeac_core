import paper from 'paper';
import { SketchFile, Options } from './index';
/** All builders exported from this method will conform to this interface
 *
 * @param scope The paper scope to build into
 * @param layer The sketch.Layer to convert into a paper.Item
 * @param sketch The Sketch file this builder can fetch resources from, if needed
 * @param options The options this library was created with - this might affect the built options
 * @returns `undefined` if this builder could not create an Item from this layer, or the created item
 */
interface BuilderFunc {
    (scope: paper.PaperScope, layer: any, sketch?: SketchFile, options?: Options): Promise<paper.Item | undefined>;
}
declare const _default: {
    rect: BuilderFunc;
    ellipse: BuilderFunc;
    fill: BuilderFunc;
    path: BuilderFunc;
    bitmap: BuilderFunc;
};
export default _default;
