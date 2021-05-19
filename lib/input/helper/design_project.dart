import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/design_logic/abstract_design_node_factory.dart';
import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/input/helper/design_page.dart';

import 'package:parabeac_core/input/sketch/entities/style/shared_style.dart';

class DesignProject implements DesignNodeFactory {
  String projectName;
  bool debug = false;
  String id;
  @override
  String pbdfType = 'project';

  DesignProject({
    this.projectName,
    this.id,
  });

  List<DesignPage> pages = [];
  List<DesignPage> miscPages = [];
  List<SharedStyle> sharedStyles = [];

  /// Parabeac Design File
  Map<String, dynamic> toPBDF() {
    Map result = <String, dynamic>{};
    result['projectName'] = projectName;
    result['pbdfType'] = pbdfType;
    result['id'] = id;

    var tmpPages = <Map>[];
    var tmpMiscPages = <Map>[];
    for (var page in pages) {
      tmpPages.add(page.toPBDF());
    }
    for (var page in miscPages) {
      tmpMiscPages.add(page.toPBDF());
    }

    for (var sharedStyle in sharedStyles) {
      result.addAll(sharedStyle.toJson());
    }

    result['pages'] = tmpPages;
    result['miscPages'] = tmpMiscPages;

    return result;
  }

  @override
  DesignNode createDesignNode(Map<String, dynamic> json) {
    // TODO: implement createDesignNode
    throw UnimplementedError();
  }

  factory DesignProject.fromPBDF(Map<String, dynamic> json) {
    var project =
        DesignProject(projectName: json['projectName'], id: json['id']);
    if (json.containsKey('pages')) {
      (json['pages'] as List)?.forEach((value) {
        if (value != null) {
          project.pages.add(DesignPage.fromPBDF(value as Map<String, dynamic>));
        }
      });
    }
    return project;
  }

  /// Returns a [Map] that represents the PBDL page with ID `pageId`,
  /// or `null` if not found.
  Map getPbdlPage(String pageId) {
    if (MainInfo().pbdf != null) {
      List pages = MainInfo().pbdf['pages'];
      return pages.singleWhere((element) => element['id'] == pageId,
          orElse: () => null);
    }
    return null;
  }

  /// Returns a [Map] that represents the PBDL screen with ID `screenId`
  /// inside `pbdlPage`'s screens property.
  Map getPbdlScreen(Map pbdlPage, String screenId) {
    if (MainInfo().pbdf != null) {
      List screens = pbdlPage['screens'];
      return screens.singleWhere((element) => element['id'] == screenId,
          orElse: () => null);
    }
    return null;
  }
}
