import 'package:parabeac_core/design_logic/abstract_design_node_factory.dart';
import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:quick_log/quick_log.dart';
import 'design_screen.dart';

import 'map_mixin.dart';

class DesignPage with MapMixin implements DesignNodeFactory {
  var log = Logger('DesignPage');

  String id;
  String imageURI;
  String name;
  bool convert;
  List<DesignScreen> screens = [];

  DesignPage({
    this.name,
    this.id,
  }) {
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
    result['pbdfType'] = pbdfType;
    result['id'] = id;
    result['name'] = name;
    result['convert'] = convert;
    for (var screen in screens) {
      addToMap('screens', result, {screen.name: screen.toPBDF()});
    }
    return result;
  }

  @override
  String pbdfType = 'design_page';

  @override
  DesignNode createDesignNode(Map<String, dynamic> json) {
    // TODO: implement createDesignNode
    throw UnimplementedError();
  }

  factory DesignPage.fromPBDF(Map<String, dynamic> json) {
    var page = DesignPage(name: json['name'], id: json['id']);
    if (json.containsKey('screens')) {
      (json['screens'] as Map)?.forEach((key, value) {
        if (value != null) {
          page.screens
              .add(DesignScreen.fromPBDF(value as Map<String, dynamic>));
        }
      });
    }
    return page;
  }
}
