import 'package:parabeac_core/design_logic/design_element.dart';

abstract class Text extends DesignElement {
  Text(this.content) : super();

  String content;
}
