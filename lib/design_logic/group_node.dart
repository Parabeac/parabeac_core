import 'package:parabeac_core/design_logic/design_node.dart';

abstract class GroupNode {
  GroupNode(
    this.children,
  );

  List children;

  @override
  String pbdfType = 'group';

  @override
  DesignNode createDesignNode(Map<String, dynamic> json) => fromPBDF(json);

  DesignNode fromPBDF(Map<String, dynamic> json) {
    // TODO implement
    return null;
  }
}
