import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/input/figma/entities/layers/canvas.dart';
import 'package:parabeac_core/input/figma/helper/figma_page.dart';
import 'package:parabeac_core/input/helper/design_project.dart';
import 'package:quick_log/src/logger.dart';

import 'figma_screen.dart';

class FigmaProject extends DesignProject {
  @override
  bool debug;

  @override
  Logger log = Logger('FigmaProject');

  @override
  String projectName;

  var figmaJson;

  FigmaPage rootScreen;

  FigmaProject(
    this.projectName,
    this.figmaJson, {
    String id,
  }) : super(id: id) {
    pages.addAll(_setConventionalPages(figmaJson['document']['children']));
  }

  List<FigmaPage> _setConventionalPages(var canvasAndArtboards) {
    var figmaPages = <FigmaPage>[];
    for (var canvas in canvasAndArtboards) {
      // Skip current canvas if its convert property is false
      var pbdlPage = getPbdlPage(canvas['id']);
      if (pbdlPage != null && !(pbdlPage['convert'] ?? true)) {
        continue;
      }

      var pg = FigmaPage(canvas['name'], canvas['id']);

      var node = Canvas.fromJson(canvas);

      for (var layer in node.children) {
        // Skip current screen if its convert property is false
        var pbdlScreen = getPbdlScreen(pbdlPage, layer.UUID);
        if (pbdlScreen != null && !(pbdlScreen['convert'] ?? true)) {
          continue;
        }
        pg.addScreen(FigmaScreen(
          layer,
          layer.UUID,
          layer.name,
        ));
      }
      figmaPages.add(pg);
    }
    return figmaPages;
  }
}
