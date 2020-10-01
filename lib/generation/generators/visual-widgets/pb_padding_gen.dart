import 'package:parabeac_core/interpret_and_optimize/entities/alignments/padding.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

import '../pb_flutter_generator.dart';
import '../pb_generator.dart';

class PBPaddingGen extends PBGenerator {
  PBPaddingGen() : super();

  String relativePadding(BUILDER_TYPE type, bool isVertical, double value) {
    if (type != null) {
      if (isVertical) {
        return 'MediaQuery.of(context).size.height * ${(value).toStringAsFixed(2)}';
      } else {
        return 'MediaQuery.of(context).size.width * ${(value).toStringAsFixed(2)}';
      }
    }
    return '${value.toStringAsFixed(2)}';
  }

  @override
  String generate(PBIntermediateNode source) {
    if (source is Padding) {
      var buffer = StringBuffer();
      buffer.write('Padding(');
      buffer.write('padding: EdgeInsets.only(');
      if (source.left != null) {
        buffer.write(
            'left: ${relativePadding(BUILDER_TYPE.BODY, false, source.left)},');
      }
      if (source.right != null) {
        buffer.write(
            'right: ${relativePadding(BUILDER_TYPE.BODY, false, source.right)},');
      }
      if (source.bottom != null) {
        buffer.write(
            'bottom: ${relativePadding(BUILDER_TYPE.BODY, true, source.bottom)},');
      }
      if (source.top != null) {
        buffer.write(
            'top: ${relativePadding(BUILDER_TYPE.BODY, true, source.top)},');
      }
      buffer.write('),');
      if (source.child != null) {
        var statement = source.child != null
            ? 'child: ${manager.generate(source.child, type: source.builder_type ?? BUILDER_TYPE.BODY)}'
            : '';
        buffer.write(statement);
      }
      buffer.write(')');
      return buffer.toString();
    }
    return '';
  }
}
