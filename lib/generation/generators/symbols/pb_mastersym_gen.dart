import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/pb_symbol_master_params.dart';
import 'package:quick_log/quick_log.dart';

import '../pb_flutter_generator.dart';

class PBMasterSymbolGenerator extends PBGenerator {
  final _parametersType = {
    'image': 'String',
    'stringValue': 'String',
    'String': 'String',
    'symbolID': 'String',
    'layerStyle': 'var',
    'TextStyle': 'TextStyle'
  };
  List<PBSymbolMasterParameter> _parameterDefinition = [];

  PBMasterSymbolGenerator() : super();

  ///Generating the parameters of the symbol master, keeping [definitions] so
  ///we can replace the generic names of the parameters by that of the real overridable node's name.
  ///However, they need to be established in all the nodes.
  String _generateParameters(List<PBSharedParameterProp> signatures,
      List<PBSymbolMasterParameter> definitions) {
    if ((signatures == null) || (signatures.isEmpty)) {
      return '';
    }
    var buffer = StringBuffer();
    // optional parameters
    buffer.write('{ ');
    for (var i = 0; i < signatures.length; i++) {
      var signature = signatures[i];
      var overridableType =
          signature.type?.toString()?.replaceAll(RegExp('.+_'), '');
      var type = _parametersType.containsKey(overridableType)
          ? _parametersType[overridableType]
          : 'var';

      if (signature.canOverride) {
        var name = signature.friendlyName;
        if (name == null) {
          continue;
        }

        buffer.write(('$type $name,'));
      }
    }
    buffer.write(' }');
    return buffer.toString();
  }

  String _generateParametersBody(PBIntermediateNode source) {
    var buffer = StringBuffer();
    _parameterDefinition.forEach((param) {
      var body = manager.generate(param,
          type: source.builder_type ?? BUILDER_TYPE.SCAFFOLD_BODY);
      if (body != null && body.isNotEmpty) {
        buffer.writeln('${param.name} ??= $body;');
      }
    });
    return buffer.toString();
  }

  var log = Logger('Symbol Master Generator');
  @override
  String generate(PBIntermediateNode source) {
    var buffer = StringBuffer();
    if (source is PBSharedMasterNode) {
      if (source.child == null) {
        return '';
      }
      var name;
      try {
        //Remove any special characters and leading numbers from the method name
        name = source.name
            .replaceAll(RegExp(r'[^\w]+'), '')
            .replaceFirst(RegExp(r'^[\d]+'), '');
        //Make first letter of method name capitalized
        name = name[0].toLowerCase() + name.substring(1);
      } catch (e, stackTrace) {
        MainInfo().sentry.captureException(
              exception: e,
              stackTrace: stackTrace,
            );
        log.error(e.toString());
      }
      buffer.write('Widget ${name}(BuildContext context, BoxConstraints constraints, ');
      var parameters = _generateParameters((source.overridableProperties ?? []),
          (source.parametersDefinition ?? []));
      buffer.write(parameters);
      buffer.write('){');
      var parameterBody = _generateParametersBody(source);
      buffer.write(parameterBody);
      buffer.write('Widget widget = ');

      var generatedWidget = manager.generate(source.child,
          type: source.builder_type ?? BUILDER_TYPE.SCAFFOLD_BODY);
      if (generatedWidget == null || generatedWidget.isEmpty) return '';
      buffer.write(generatedWidget);
      buffer.write(';\nreturn widget;\n}');
      return buffer.toString();
    }
  }
}
