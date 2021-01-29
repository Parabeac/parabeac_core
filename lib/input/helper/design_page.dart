import 'package:quick_log/quick_log.dart';
import 'design_screen.dart';

import 'map_mixin.dart';

class DesignPage with MapMixin {
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

  /// Parabeac Design File
  Map<String, dynamic> toPBDF() {
    Map<String, dynamic> result = {};
    for (var screen in screens) {
      addToMap('screens', result, {screen.name: screen.toPBDF()});
    }
    return result;
  }
}
