import 'package:parabeac_core/generation/generators/attribute-helper/pb_size_helper.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_bitmap.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

class PBBitmapGenerator extends PBGenerator {
  var _sizehelper;

  PBBitmapGenerator() : super() {
    _sizehelper = PBSizeHelper();
  }

  @override
  String generate(PBIntermediateNode source, PBContext generatorContext) {
    var buffer = StringBuffer();

    buffer.write('Image.asset(');
    // if (SN_UUIDtoVarName.containsKey('${source.UUID}_image')) {
    //   buffer.write('${SN_UUIDtoVarName[source.UUID + '_image']} ?? ');
    // } else if (SN_UUIDtoVarName.containsKey('${source.UUID}_layerStyle')) {
    //   buffer.write('${SN_UUIDtoVarName[source.UUID + '_layerStyle']} ?? ');
    // }
    buffer.write(
        '\'assets/${source is InheritedBitmap ? source.referenceImage : ('images/' + source.UUID + '.png')}\', ${_sizehelper.generate(source, generatorContext)})');
    return buffer.toString();
  }
}
