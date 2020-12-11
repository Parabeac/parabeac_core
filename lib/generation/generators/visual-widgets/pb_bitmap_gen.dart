import 'package:parabeac_core/generation/generators/attribute-helper/pb_size_helper.dart';
import 'package:parabeac_core/generation/generators/pb_flutter_generator.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/input/sketch/helper/symbol_node_mixin.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_bitmap.dart';

class PBBitmapGenerator extends PBGenerator {
  var _sizehelper;

  PBBitmapGenerator() : super() {
    _sizehelper = PBSizeHelper();
  }

  @override
  String generate(PBIntermediateNode source) {
    var buffer = StringBuffer();
    buffer.write('Image.asset(');
    if (source.builder_type == BUILDER_TYPE.SHARED_MASTER) {
      // see if source is overridden
      String ovrName = SN_UUIDtoVarName[source.UUID + '_image'];
      if (ovrName != null) {
        buffer.write("${ovrName} ?? ");
      }
    }
    buffer.write(
        '\'assets/${source is InheritedBitmap ? source.referenceImage : ('images/' + source.UUID + '.png')}\', ${_sizehelper.generate(source)})');
    return buffer.toString();
  }
}
