import 'dart:convert';

import 'package:parabeac_core/design_logic/abstract_design_node_factory.dart';
import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/input/helper/design_page.dart';
import 'package:parabeac_core/input/helper/map_mixin.dart';
import 'package:parabeac_core/input/sketch/entities/style/shared_style.dart';

class DesignProject with MapMixin implements DesignNodeFactory {
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

  @override
  DesignNode createDesignNode(Map<String, dynamic> json) {
    // TODO: implement createDesignNode
    throw UnimplementedError();
  }

  factory DesignProject.fromPBDF(Map<String, dynamic> json) {
    var project =
        DesignProject(projectName: json['projectName'], id: json['id']);
    if (json.containsKey('pages')) {
      (json['pages'] as Map)?.forEach((key, value) {
        if (value != null) {
          project.pages.add(DesignPage.fromPBDF(value as Map<String, dynamic>));
        }
      });
    }
    return project;
  }
}
