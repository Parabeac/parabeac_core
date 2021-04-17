import 'package:parabeac_core/generation/generators/attribute-helper/pb_generator_context.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/util/pb_generation_view_data.dart';
import 'package:parabeac_core/generation/generators/util/pb_input_formatter.dart';
import 'package:parabeac_core/input/sketch/entities/style/shared_style.dart';
import 'package:parabeac_core/input/sketch/entities/style/text_style.dart';
import 'package:parabeac_core/input/sketch/helper/symbol_node_mixin.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_bitmap.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_gen_cache.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_symbol_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/pb_symbol_instance_overridable_value.dart';
import 'package:quick_log/quick_log.dart';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:recase/recase.dart';

class PBSymbolInstanceGenerator extends PBGenerator {
  PBSymbolInstanceGenerator() : super();

  var log = Logger('Symbol Instance Generator');

  @override
  String generate(
      PBIntermediateNode source, GeneratorContext generatorContext) {
    if (source is PBSharedInstanceIntermediateNode) {
      var method_signature = source.functionCallName?.pascalCase;
      if (method_signature == null) {
        log.error(' Could not find master name on: $source');
        return 'Container(/** This Symbol was not found **/)';
      }

      var overrideProp = SN_UUIDtoVarName[source.UUID + '_symbolID'];

      method_signature = PBInputFormatter.formatLabel(method_signature,
          destroyDigits: false, spaceToUnderscore: false, isTitle: true);
      var buffer = StringBuffer();

      buffer.write('LayoutBuilder( \n');
      buffer.write('  builder: (context, constraints) {\n');
      buffer.write('    return ');

      if (overrideProp != null) {
        buffer.write('${overrideProp} ?? ');
      }

      buffer.write(method_signature);
      buffer.write('(');
      buffer.write('constraints,');

      for (var param in source.sharedParamValues ?? []) {
        switch (param.type) {
          case PBSharedInstanceIntermediateNode:
            String siString = genSymbolInstance(
                param.UUID,
                param.value,
                source.overrideValues,
                source.managerData
            );
            if (siString != '') {
              buffer.write('${param.name}: ');
              buffer.write(siString);
            }
            break;
          case InheritedBitmap:
            buffer.write('${param.name}: \"assets/${param.value["_ref"]}\",');
            break;
          case TextStyle:
            // hack to include import
            source.currentContext.treeRoot.data.addImport(
                'package:${MainInfo().projectName}/document/shared_props.g.dart');
            buffer.write(
                '${param.name}: ${SharedStyle_UUIDToName[param.value] ?? "TextStyle()"},');
            break;
          default:
            buffer.write('${param.name}: \"${param.value}\",');
            break;
        }
      }
      // end of return function();
      buffer.write(');\n');
      // end of builder: (context, constraints) {
      buffer.write('}\n');
      // end of LayoutBuilder()
      buffer.write(')');
      return buffer.toString();
    }
    return '';
  }

  PBSharedMasterNode getMasterSymbol(String UUID) {

    var masterSymbol;
    var nodeFound = PBSymbolStorage().getAllSymbolById(UUID);
    if (nodeFound is PBSharedMasterNode) {
      masterSymbol = nodeFound;
    } else if (nodeFound is PBSharedInstanceIntermediateNode) {
      // If storage found an instance, get its master
      masterSymbol =
          PBSymbolStorage().getSharedMasterNodeBySymbolID(nodeFound.SYMBOL_ID);
    } else {
      // Try to find master by looking for the master's SYMBOL_ID
      masterSymbol = PBSymbolStorage().getSharedMasterNodeBySymbolID(UUID);
    }

    return masterSymbol;

  }

  String genSymbolInstance(String overrideUUID, String UUID,
      List<PBSymbolInstanceOverridableValue> overrideValues,
      PBGenerationViewData managerData,
      {int depth = 1}) {

    if ((UUID == null) || (UUID == '')) {
      return '';
    }

    var masterSymbol = getMasterSymbol(UUID);

    // file could have override names that don't exist?  That's really odd, but we have a file that does that.
    if (masterSymbol == null) {
      return '';
    }

    // include import
    Set<String> path = PBGenCache().getPaths(masterSymbol.SYMBOL_ID);
    if (path.isEmpty) {
      log.warning("Can't find path for Master Symbol with UUID: ${UUID}");
    } else {
      managerData.addImport(path.first);
    }

    var buffer = StringBuffer();
    buffer.write('${masterSymbol.friendlyName}(constraints, ');
    for (var ovrValue in overrideValues) {
      var ovrUUIDStrings = ovrValue.UUID.split('/');
      if ((ovrUUIDStrings.length == depth + 1) &&
          (ovrUUIDStrings[depth - 1] == overrideUUID)) {
        var ovrUUID = ovrUUIDStrings[depth];
        switch (ovrValue.type) {
          case PBSharedInstanceIntermediateNode:
            buffer.write(genSymbolInstance(
                ovrValue.value, ovrUUID, overrideValues,
                managerData,
                depth: depth + 1));

            break;
          case InheritedBitmap:
            var name = SN_UUIDtoVarName[ovrUUID + '_image'];
            buffer.write('${name}: \"assets/${ovrValue.value["_ref"]}\",');
            break;
          case TextStyle:
            var name = SN_UUIDtoVarName[ovrUUID + '_textStyle'];
            buffer.write(
                '${name}: ${SharedStyle_UUIDToName[ovrValue.value] ?? "TextStyle()"},');
            break;
          default:
            var name = SN_UUIDtoVarName[ovrUUID];
            buffer.write('${name}: \"${ovrValue.value}\",');
            break;
        }
      }
    }
    buffer.write('),');
    return buffer.toString();
  }
}
