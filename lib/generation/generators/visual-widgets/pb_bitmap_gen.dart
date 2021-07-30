import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/attribute-helper/pb_size_helper.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_bitmap.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:path/path.dart' as p;

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

    // TODO: do we need this?
    var imagePath = source is InheritedBitmap
        ? p.relative(source.referenceImage, from: MainInfo().outputPath)
        : ('assets/images/' + source.UUID + '.png');

    buffer.write(
        '\'$imagePath\', ${_sizehelper.generate(source, generatorContext)})');
    return buffer.toString();
  }
}
