import 'package:quick_log/quick_log.dart';

import 'design_screen.dart';

class DesignPage {
  var log = Logger('DesignPage');

  String id;
  String imageURI;
  String name;
  bool convert;
  List<DesignScreen> screens = [];

  DesignPage(
    this.name,
    this.id,
  ) {
    screens = [];
  }

  void addScreen(DesignScreen item) {
    screens.add(item);
  }

  List<DesignScreen> getPageItems() {
    log.info('We encountered a page that has ${screens.length} page items.');
    return screens;
  }

  Map<String, Object> toJson() {
    Map<String, Object> result = {};
    result['name'] = name;
    for (var screen in screens) {
      result.addAll(screen.designNode.toJson());
    }
    return result;
  }
}
