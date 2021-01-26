import 'package:parabeac_core/input/helper/design_page.dart';
import 'package:parabeac_core/input/sketch/entities/style/shared_style.dart';
import 'package:quick_log/quick_log.dart';

abstract class DesignProject {
  var log = Logger('DesignProject');
  String projectName;
  bool debug = false;
  String id;

  List<DesignPage> pages = [];
  List<DesignPage> miscPages = [];
  List<SharedStyle> sharedStyles = [];

  Map<String, Object> toJson() {
    var result = <String, Object>{};
    result['projectName'] = projectName;
    for (var page in pages) {
      result.addAll({page.name: page.toJson()});
    }
    for (var page in miscPages) {
      result.addAll({page.name: page.toJson()});
    }

    for (var sharedStyle in sharedStyles) {
      result.addAll(sharedStyle.toJson());
    }

    return result;
  }
}
