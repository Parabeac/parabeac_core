import 'package:parabeac_core/input/sketch/entities/layers/abstract_layer.dart';
import 'package:parabeac_core/input/sketch/helper/sketch_page.dart';

class SketchPageItem {
  SketchNode root;
  SketchPage parentPage;
  SketchPageItem(this.root, this.parentPage);

  Map<String, Object> toJson() => root.toJson();
}
