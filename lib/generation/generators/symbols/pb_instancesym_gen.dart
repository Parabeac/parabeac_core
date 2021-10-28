import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/util/pb_input_formatter.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_bitmap_gen.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/override_helper.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_symbol_storage.dart';
import 'package:quick_log/quick_log.dart';
import 'package:recase/recase.dart';

class PBSymbolInstanceGenerator extends PBGenerator {
  PBSymbolInstanceGenerator() : super();

  var log = Logger('Symbol Instance Generator');

  @override
  String generate(PBIntermediateNode source, PBContext generatorContext) {
    if (source is PBSharedInstanceIntermediateNode) {
      var buffer = StringBuffer();
      buffer.write('LayoutBuilder( \n');
      buffer.write('  builder: (context, constraints) {\n');
      buffer.write('    return ');

      // If storage found an instance, get its master
      var masterSymbol =
          PBSymbolStorage().getSharedMasterNodeBySymbolID(source.SYMBOL_ID);

      // recursively generate Symbol Instance constructors with overrides
      buffer.write(genSymbolInstance(
        source.SYMBOL_ID,
        source.sharedParamValues,
        generatorContext,
      ));

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
    List<PBInstanceOverride> overrideValues,
    PBContext context, {
    bool topLevel = true,
    String UUIDPath = '',
  }) {
    if ((UUID == null) || (UUID == '')) {
      return '';
    }

    var buffer = StringBuffer();
    var masterSymbol = getMasterSymbol(UUID);

    // file could have override names that don't exist?  That's really odd, but we have a file that does that.
    if (masterSymbol == null) {
      log.error(' Could not find master symbol for UUID:: $UUID');
      return 'Container(/** This Symbol was not found **/)';
    }

    var symName = masterSymbol.name.snakeCase;
    if (symName == null) {
      log.error(' Could not find master name on: $masterSymbol');
      return 'Container(/** This Symbol was not found **/)';
    }

    symName = PBInputFormatter.formatLabel(symName,
        destroyDigits: false, spaceToUnderscore: false, isTitle: true);

    buffer.write(symName.pascalCase);
    buffer.write('(\n');
    buffer.write('constraints,\n');

    // Make sure override property of every value is overridable
    if (overrideValues != null) {
      overrideValues.removeWhere((value) {
        var override = OverrideHelper.getProperty(value.UUID, value.type);
        return override == null || override.value == null;
      });

      _formatNameAndValues(overrideValues, context);
      for (var element in overrideValues) {
        if (element.overrideName != null && element.initialValue != null) {
          // If the type is image, we should print the whole widget
          // so the end user can place whatever kind of widget
          // TODO: Refactor so it place the image from the instance not from component
          if (element.type == 'image') {
            var elementCode =
                element.value.generator.generate(element.value, context);

            buffer.write('${element.overrideName}: $elementCode,');
          } else {
            buffer.write('${element.overrideName}: ${element.value},');
          }
        }
      }
    }

    buffer.write(')\n');

    return buffer.toString();
  }

  /// Traverses `params` and attempts to find the override `name` and `value` for each parameter.
  void _formatNameAndValues(
      List<PBInstanceOverride> params, PBContext context) {
    params.forEach((param) {
      var overrideProp = OverrideHelper.getProperty(param.UUID, param.type);

      if (overrideProp != null) {
        param.overrideName = overrideProp.propertyName;
        // Find and reference symbol master if overriding a symbol
        if (param.type == 'symbolID') {
          var instance = PBSharedInstanceIntermediateNode(
            param.UUID,
            null,
            SYMBOL_ID: param.initialValue['name'],
            name: param.overrideName,
            overrideValues: [],
            sharedParamValues: [],
          );
          var code = instance.generator.generate(instance, context);
          param.initialValue['name'] = code;
          // Add single quotes to parameter value for override
        } else if (!param.initialValue['name'].contains('\'')) {
          param.initialValue['name'] = '\'${param.initialValue["name"]}\'';
        }
      }
    });
  }
}
