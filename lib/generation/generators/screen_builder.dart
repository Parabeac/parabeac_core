import 'package:build/build.dart';
import 'package:parabeac_core/generation/generators/pb_flutter_generator.dart';

Builder simpleBuilder(BuilderOptions options) => SimpleBuilder();

class SimpleBuilder extends Builder {
  final String GLOBAL_SYMBOL_KEY = 'globalSymbols';

  @override
  Map<String, List<String>> get buildExtensions => const <String, List<String>>{
        '.json': <String>['.dart']
      };

  @override
  Future<void> build(BuildStep buildStep) async {
    print('GENERATING CODE');
    Map<String, Object> source;
    final outputId = buildStep.inputId.changeExtension('.dart');

    if (source.containsKey(GLOBAL_SYMBOL_KEY)) {
      _generateArray(source[GLOBAL_SYMBOL_KEY], outputId, buildStep);
    }
  }

  void _generateArray(List data, var output_id, var build_step) {
    data ??= [];
    var buffer = StringBuffer();
    buffer.write("import \'package:flutter/material.dart\';\n");
    _generateCode(output_id, buffer.toString(), build_step);
  }

  ///Generating the code
  ///`buildMethod`: is the string that represents the code
  ///`outputID`: is the output general info
  void _generateCode(var output_id, var build_method, var build_step) =>
      build_step.writeAsString(output_id, build_method);
}
