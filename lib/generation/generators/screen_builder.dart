import 'package:build/build.dart';
import 'package:parabeac_core/generation/generators/pb_flutter_generator.dart';

Builder simpleBuilder(BuilderOptions options) => SimpleBuilder();

class SimpleBuilder extends Builder {
  // PBGenerationManager manager = PBGenerationManager(debug: true);
  final String GLOBAL_SYMBOL_KEY = 'globalSymbols';

  @override
  Map<String, List<String>> get buildExtensions => const <String, List<String>>{
        '.json': <String>['.dart']
      };

  @override
  Future<void> build(BuildStep buildStep) async {
    print('GENERATING CODE');
    Map<String, Object> source;
    final AssetId outputId = buildStep.inputId.changeExtension('.dart');

    if (source.containsKey(GLOBAL_SYMBOL_KEY)) {
      _generateArray(source[GLOBAL_SYMBOL_KEY], outputId, buildStep);
    }
  }

  ///Getting the output type based on jsonfile contents
  BUILDER_TYPE _getType(Map jsonFile) {
    for (var entry in jsonFile.entries) {
      var value = entry.value.toString();
      if (value.contains('Scaffold')) {
        return BUILDER_TYPE.STATEFUL_WIDGET;
      } else if (value.contains(GLOBAL_SYMBOL_KEY) ||
          value.contains('PBSymbolMaster')) {
        return BUILDER_TYPE.SYMBOL_MASTER;
      } else {
        return BUILDER_TYPE.STATEFUL_WIDGET;
      }
    }
  }

  void _generateArray(List data, var output_id, var build_step) {
    data ??= [];
    var buffer = StringBuffer();
    buffer.write("import \'package:flutter/material.dart\';\n");
    print('DATA:' + data.toString());
    _generateCode(output_id, buffer.toString(), build_step);
  }

  ///Generating the code
  ///`buildMethod`: is the string that represents the code
  ///`outputID`: is the output general info
  void _generateCode(var output_id, var build_method, var build_step) =>
      build_step.writeAsString(output_id, build_method);
}
