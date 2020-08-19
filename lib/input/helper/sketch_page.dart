import 'package:quick_log/quick_log.dart';
import 'package:parabeac_core/input/helper/sketch_page_item.dart';

class SketchPage {
  var log = Logger('Sketch');

  String name;
  List<SketchPageItem> _pageItems = [];

  SketchPage(
    this.name,
  ) {
    _pageItems = [];
  }

  void addPageItem(SketchPageItem item) {
    _pageItems.add(item);
  }

  List<SketchPageItem> getPageItems() {
    log.info('We encountered a page that has 0 page items.');
    return _pageItems;
  }

  Map<String, Object> toJson() {
    Map<String, Object> result = {};
    result['name'] = name;
    for (var item in _pageItems) {
      result.addAll(item.root.toJson());
    }
    return result;
  }
}
