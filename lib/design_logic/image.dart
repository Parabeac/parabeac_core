import 'package:parabeac_core/design_logic/design_element.dart';
import 'package:parabeac_core/design_logic/design_node.dart';

abstract class Image extends DesignElement {
  Image(
    this.imageReference,
  ) : super();

  String imageReference;

  @override
  String pbdfType = 'image';

  @override
  DesignNode createDesignNode(Map<String, dynamic> json) => fromPBDF(json);

  DesignNode fromPBDF(Map<String, dynamic> json) {
    // TODO implement
    return null;
  }
}
