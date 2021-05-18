import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/pb_variable.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

class PBSymbolMasterParamGen extends PBGenerator {
  PBSymbolMasterParamGen() : super();

  @override
  String generate(PBIntermediateNode source, PBContext generatorContext) {
    //TODO: is PBParam correct here?
    var name = (source as PBVariable).variableName;

    if (name == null) {
      return '';
    }
    return name;
  }
}
