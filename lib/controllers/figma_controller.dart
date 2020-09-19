import 'package:parabeac_core/controllers/controller.dart';
import 'package:parabeac_core/input/figma/helper/figma_node_tree.dart';
import 'package:quick_log/quick_log.dart';

class FigmaController extends Controller {
  ///SERVICE
  @override
  var log = Logger('FigmaController');

  FigmaController();

  @override
  void convertFile(var jsonFigma, var outputPath, var configurationPath) async {
    configure(configurationPath);

    var figmaNodeTree = generateFigmaTree(jsonFigma, outputPath);

    ///TODO:
  }

  FigmaNodeTree generateFigmaTree(var jsonFigma, var projectname) {
    try {
      return FigmaNodeTree(projectname, jsonFigma);
    } catch (e, stackTrace) {
      print(e);
      return null;
    }
  }
}
