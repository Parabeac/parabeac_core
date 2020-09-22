import 'package:parabeac_core/input/helper/page.dart';
import 'package:quick_log/quick_log.dart';

abstract class NodeTree {
  var log = Logger('NodeTree');
  String projectName;
  bool debug = false;

  List<Page> pages = [];
  List<Page> miscPages = [];

  Map<String, Object> toJson() {
    var result = <String, Object>{};
    result['projectName'] = projectName;
    for (var page in pages) {
      result.addAll(page.toJson());
    }
    for (var page in miscPages) {
      result.addAll(page.toJson());
    }
    return result;
  }
}
