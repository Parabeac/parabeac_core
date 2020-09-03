import 'package:parabeac_core/design_logic/design_element.dart';

abstract class Image extends DesignElement {
  Image(
    this.imageReference,
  ) : super();

  String imageReference;

  // factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);
  // Map<String, dynamic> toJson() => _$ImageToJson(this);
}
