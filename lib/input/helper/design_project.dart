import 'package:parabeac_core/input/helper/design_page.dart';
import 'package:parabeac_core/input/helper/map_mixin.dart';
import 'package:parabeac_core/input/sketch/entities/style/shared_style.dart';

class DesignProject with MapMixin {
  String projectName;
  bool debug = false;
  String id;

  List<DesignPage> pages = [];
  List<DesignPage> miscPages = [];
  List<SharedStyle> sharedStyles = [];

  /// Parabeac Design File
  Map<String, dynamic> toPBDF() {
    Map result = <String, dynamic>{};
    result['projectName'] = projectName;
    for (var page in pages) {
      addToMap('pages', result, {page.name: page.toPBDF()});
    }
    for (var page in miscPages) {
      addToMap('miscPages', result, {page.name: page.toPBDF()});
    }

    for (var sharedStyle in sharedStyles) {
      result.addAll(sharedStyle.toJson());
    }

    return result;
  }
}
