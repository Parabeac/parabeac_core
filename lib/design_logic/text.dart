import 'package:parabeac_core/design_logic/design_element.dart';
import 'package:parabeac_core/design_logic/design_node.dart';

abstract class Text extends DesignElement {
  Text(this.content) : super();

  String content;

  @override
  String pbdfType = 'text';

  @override
  DesignNode createDesignNode(Map<String, dynamic> json) => fromPBDF(json);

  DesignNode fromPBDF(Map<String, dynamic> json) {
    // TODO implement
    return null;
  }
}
