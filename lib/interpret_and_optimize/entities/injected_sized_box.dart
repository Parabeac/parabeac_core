import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

class IntermediateSizedBox extends PBVisualIntermediateNode {
  num height, width;

  IntermediateSizedBox({
    String UUID,
    Rectangle3D<num> frame,
    String name,
    this.width,
    this.height,
  }) : super(UUID, frame, name) {
    generator = PBSizedBoxGenerator();
  }
}

class PBSizedBoxGenerator extends PBGenerator {
  @override
  String generate(PBIntermediateNode source, PBContext context) {
    if (source is IntermediateSizedBox) {
      var buffer = StringBuffer();

      buffer.write('SizedBox(');

      if (source.height != null) {
        if (source.height < 0) {
          buffer.write('height: 0.0');
        } else {
          buffer.write('height: ${source.height},');
        }
      }
      if (source.width != null) {
        if (source.width < 0) {
          buffer.write('width: 0.0');
        } else {
          buffer.write('width: ${source.width},');
        }
      }

      buffer.write(')');

      return buffer.toString();
    }
  }
}
