import 'package:parabeac_core/generation/flutter_project_builder/import_helper.dart';
import 'package:parabeac_core/generation/generators/attribute-helper/pb_generator_context.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/util/pb_generation_view_data.dart';
import 'package:parabeac_core/generation/generators/util/pb_input_formatter.dart';
import 'package:parabeac_core/input/sketch/entities/style/shared_style.dart';
import 'package:parabeac_core/input/sketch/entities/style/style.dart';
import 'package:parabeac_core/input/sketch/entities/style/text_style.dart';
import 'package:parabeac_core/input/sketch/helper/symbol_node_mixin.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_bitmap.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_gen_cache.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_symbol_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/pb_symbol_instance_overridable_value.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/pb_symbol_master_params.dart';
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
      var buffer = StringBuffer();
      buffer.write('LayoutBuilder( \n');
      buffer.write('  builder: (context, constraints) {\n');
      buffer.write('    return ');

      // If storage found an instance, get its master
      var masterSymbol =
          PBSymbolStorage().getSharedMasterNodeBySymbolID(source.SYMBOL_ID);

      // recursively generate Symbol Instance constructors with overrides
      buffer.write(genSymbolInstance(source.UUID, source.overrideValuesMap,
          masterSymbol.parametersDefsMap, source.managerData));

      // end of return <genSymbolInstance>();
      buffer.write(';\n');
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

  String genSymbolInstance(
      String UUID,
      Map<String, PBSymbolInstanceOverridableValue> mapOverrideValues,
      Map<String, PBSymbolMasterParameter> mapParameterValues,
      PBGenerationViewData managerData,
      { bool topLevel = true,
        String UUIDPath = ''}) {
    if ((UUID == null) || (UUID == '')) {
      return '';
    }

    var buffer = StringBuffer();
    var masterSymbol = getMasterSymbol(UUID);

    // file could have override names that don't exist?  That's really odd, but we have a file that does that.
    if (masterSymbol == null) {
      log.error(' Could not find master symbol for UUID:: $UUID');
      return 'Container(/** This Symbol was not found **/)});';
    }

    var symName = masterSymbol.name;
    if (symName == null) {
      log.error(' Could not find master name on: $masterSymbol');
      return 'Container(/** This Symbol was not found **/)});';
    }

    symName = PBInputFormatter.formatLabel(symName,
        destroyDigits: false, spaceToUnderscore: false, isTitle: true);

    var path = 'symbols';
    if (masterSymbol.name.contains('/')) {
      path = ImportHelper
          .getName(masterSymbol.name)
          .snakeCase;
    }
    managerData.addImport(
        'package:${MainInfo().projectName}/view/$path/${symName.snakeCase}.dart');

    // if this symbol is overridable, then put variable name + null check
    var overrideProp = SN_UUIDtoVarName[UUID + '_symbolID'];
    if (overrideProp != null) {
      buffer.write('$overrideProp ?? ');
    }

    buffer.write(symName.pascalCase);
    buffer.write('(\n');
    buffer.write('constraints,\n');

    // need to iterate through master symbol parametersDefsMap to pass parent variables down to children

    masterSymbol.parametersDefsMap.forEach((overrideName, smParameter) {
      var ovrValue = '';
      overrideName = UUIDPath + overrideName;
      if (mapOverrideValues.containsKey(overrideName)) {
        var param = mapOverrideValues[overrideName];
        switch (param.type) {
          case PBSharedInstanceIntermediateNode:
            ovrValue = genSymbolInstance(
              param.value,
              mapOverrideValues,
              mapParameterValues,
              managerData,
              topLevel: false,
              UUIDPath: '$UUIDPath${param.UUID}/',
            );
            break;
          case InheritedBitmap:
            ovrValue = '\"assets/${param.value["_ref"]}\"';
            break;
          case TextStyle:
            // hack to include import
            managerData.addImport(
                'package:${MainInfo().projectName}/document/shared_props.g.dart');
            ovrValue = '${SharedStyle_UUIDToName[param.value]}.textStyle';
            break;
          case Style:
            // hack to include import
            managerData.addImport(
                'package:${MainInfo().projectName}/document/shared_props.g.dart');
            ovrValue = '${SharedStyle_UUIDToName[param.value]}';
            break;
          case String:
            ovrValue = '\"${param.value}\"';
            break;
          default:
            log.info(
                'Unknown type ${param.type.toString()} in parameter values for symbol instance.\n');
        }
      }
      // get parameter name to pass to widget constructor
      var friendlyName = SN_UUIDtoVarName[
          PBInputFormatter.findLastOf(smParameter.propertyName, '/')];
      var paramName = '';
      // check if parent widget has parameter to pass down to children
      if (managerData.hasParams &&
          mapParameterValues.containsKey(smParameter.propertyName)) {
        // yes, so pass down with optional null check
        paramName = friendlyName;
        if (ovrValue != '') {
          paramName += ' ?? ';
        }
      }
      if ((ovrValue != '') || (paramName != '')) {
        buffer.write('$friendlyName: $paramName$ovrValue,\n');
      }
    });

    buffer.write(')\n');

    return buffer.toString();
  }
}
