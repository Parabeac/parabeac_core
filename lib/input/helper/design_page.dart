import 'package:parabeac_core/design_logic/abstract_design_node_factory.dart';
import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:quick_log/quick_log.dart';
import 'design_screen.dart';

class DesignPage implements DesignNodeFactory {
  var log = Logger('DesignPage');

  String id;
  String imageURI;
  String name;
  bool convert = true;
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
    var result = <String, dynamic>{};
    result['pbdfType'] = pbdfType;
    result['id'] = id;
    result['name'] = name;
    result['convert'] = convert;

    var tempScreens = <Map>[];
    for (var screen in screens) {
      tempScreens.add(screen.toPBDF());
    }
    result['screens'] = tempScreens;
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
      (json['screens'] as List)?.forEach((value) {
        if (value != null && (value['convert'] ?? true)) {
          page.screens
              .add(DesignScreen.fromPBDF(value as Map<String, dynamic>));
        }
      });
    }
    return page;
  }
}
