import 'package:parabeac_core/input/figma/entities/layers/canvas.dart';
import 'package:parabeac_core/input/figma/helper/figma_page.dart';
import 'package:parabeac_core/input/helper/node_tree.dart';
import 'package:quick_log/src/logger.dart';

class FigmaNodeTree implements NodeTree {
  @override
  bool debug;

  @override
  Logger log = Logger('FigmaNodeTree');

  @override
  String projectName;

  var figmaJson;

  List<FigmaPage> pages = [];

  FigmaPage rootScreen;

  FigmaNodeTree(this.projectName, this.figmaJson) {
    // pages.addAll(_setConventionalPages(figmaJson['document']['children']));
    _setConventionalPages(figmaJson['document']['children']);
  }

  List<FigmaPage> _setConventionalPages(var canvasAndArtboards) {
    var figmaPages = <FigmaPage>[];
    for (var canvas in canvasAndArtboards) {
      var pg = FigmaPage(canvas['name']);

      var node = Canvas.fromJson(canvas);
      print('lole');
    }
    return figmaPages;
  }
}
