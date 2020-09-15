import 'package:parabeac_core/design_logic/design_element.dart';

abstract class Image extends DesignElement {
  Image(
    this.imageReference,
  ) : super();

  String imageReference;
}
