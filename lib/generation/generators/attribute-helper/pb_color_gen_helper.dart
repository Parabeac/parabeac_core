import 'package:parabeac_core/generation/generators/attribute-helper/pb_attribute_gen_helper.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

class PBColorGenHelper extends PBAttributesHelper {
  PBColorGenHelper() : super();

  @override
  String generate(PBIntermediateNode source) {
    var statement = '';
    if (source == null) {
      return statement;
    }
    if (source is InheritedScaffold) {
      var scaffold = source;
      if (scaffold.auxillaryData.color == null) {
        statement = '';
      } else {
        statement = findDefaultColor(scaffold.auxillaryData.color) != null
            ? 'backgroundColor: ${findDefaultColor(scaffold.auxillaryData.color)},'
            : 'backgroundColor: Color(${scaffold.auxillaryData.color}),\n';
      }
    } else if (source.auxillaryData.color == null) {
      statement = '';
    } else {
      if (source is! InheritedContainer) {
        statement = findDefaultColor(source.auxillaryData.color) != null
            ? 'color: ${findDefaultColor(source.auxillaryData.color)},'
            : 'color: Color(${source.auxillaryData.color}),\n';
      } else if ((source as InheritedContainer).isBackgroundVisible) {
        statement = findDefaultColor(source.auxillaryData.color) != null
            ? 'color: ${findDefaultColor(source.auxillaryData.color)},'
            : 'color: Color(${source.auxillaryData.color}),\n';
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
