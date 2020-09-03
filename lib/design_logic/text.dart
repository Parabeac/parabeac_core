import 'package:parabeac_core/design_logic/design_element.dart';

abstract class Text extends DesignElement {
  Text(this.content) : super();

  String content;

  // factory Text.fromJson(Map<String, dynamic> json) => _$TextFromJson(json);
  // Map<String, dynamic> toJson() => _$TextToJson(this);
}
