import 'package:parabeac_core/generation/generators/attribute-helper/pb_attribute_gen_helper.dart';
import 'package:parabeac_core/generation/generators/attribute-helper/pb_generator_context.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

class PBColorGenHelper extends PBAttributesHelper {
  PBColorGenHelper() : super();

  @override
  String generate(
      PBIntermediateNode source, GeneratorContext generatorContext) {
    var statement = '';
    if (source == null) {
      return statement;
    }
    if (source is InheritedScaffold) {
      var scaffold = source;
      if (scaffold.auxiliaryData.color == null) {
        statement = '';
      } else {
        statement = findDefaultColor(scaffold.auxiliaryData.color) != null
            ? 'backgroundColor: ${findDefaultColor(scaffold.auxiliaryData.color)},'
            : 'backgroundColor: Color(${scaffold.auxiliaryData.color}),\n';
      }
    } else if (source.auxiliaryData.color == null) {
      statement = '';
    } else {
      if (source is! InheritedContainer) {
        statement = findDefaultColor(source.auxiliaryData.color) != null
            ? 'color: ${findDefaultColor(source.auxiliaryData.color)},'
            : 'color: Color(${source.auxiliaryData.color}),\n';
      } else if ((source as InheritedContainer).isBackgroundVisible) {
        statement = findDefaultColor(source.auxiliaryData.color) != null
            ? 'color: ${findDefaultColor(source.auxiliaryData.color)},'
            : 'color: Color(${source.auxiliaryData.color}),\n';
      } else {
        statement = '';
      }
    }
    return statement;
  }

  String findDefaultColor(String hex) {
    switch (hex) {
      case '0xffffffff':
        return 'Colors.white';
        break;
      case '0xff000000':
        return 'Colors.black';
        break;
    }
    return null;
  }
}
