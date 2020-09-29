import 'package:parabeac_core/design_logic/design_element.dart';
import 'package:parabeac_core/design_logic/pb_text_style.dart';

abstract class Text extends DesignElement {
  Text(this.content) : super();

  String content;
  PBTextStyle textStyle;
}
