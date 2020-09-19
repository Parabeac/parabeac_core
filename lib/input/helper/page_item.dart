import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/input/helper/page.dart';

class PageItem {
  DesignNode root;
  Page parentPage;
  PageItem(this.root, this.parentPage);

  Map<String, Object> toJson() => root.toJson();
}
