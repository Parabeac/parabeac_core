import 'package:parabeac_core/input/helper/page_item.dart';
import 'package:quick_log/quick_log.dart';

class Page {
  var log = Logger('Sketch');

  String name;
  List<PageItem> _pageItems = [];

  Page(
    this.name,
  ) {
    _pageItems = [];
  }

  void addPageItem(PageItem item) {
    _pageItems.add(item);
  }

  List<PageItem> getPageItems() {
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
