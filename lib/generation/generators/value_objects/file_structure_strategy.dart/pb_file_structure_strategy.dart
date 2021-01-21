import 'dart:io';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_project.dart';
import 'package:quick_log/quick_log.dart';
import 'package:recase/recase.dart';
import 'package:parabeac_core/generation/generators/writers/pb_page_writer.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_gen_cache.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';

///Responsible for creating a particular file structure depending in the structure
///
///For example, in the provider strategy, there would be a directory for the models and the providers,
///while something like BLoC will assign a directory to a single
abstract class FileStructureStrategy {
  ///The path of where all the views are going to be generated.
  ///
  ///The views is anything that is not a screen, for example, symbol masters
  ///are going to be generated in this folder if not specified otherwise.
  final RELATIVE_VIEW_PATH = 'lib/view/';

  ///The path of where all the screens are going to be generated.
  final RELATIVE_SCREEN_PATH = 'lib/screens/';

  Logger logger;

  ///Path of where the project is generated
  final String GENERATED_PROJECT_PATH;

  final PBProject _pbProject;

  ///The page writer used to generated the actual files.
  final PBPageWriter _pageWriter;
  PBPageWriter get pageWriter => _pageWriter;

  ///Indicator that signals if the required directories are constructed.
  ///
  ///Before generating any files, the caller must call the [setUpDirectories]
  bool isSetUp = false;

  String _screenDirectoryPath;
  String _viewDirectoryPath;

  FileStructureStrategy(
      this.GENERATED_PROJECT_PATH, this._pageWriter, this._pbProject) {
    logger = Logger(runtimeType.toString());
  }

  ///Setting up the required directories for the [FileStructureStrategy] to write the corresponding files.
  ///
  ///Default directories that are going to be generated is the
  ///[RELATIVE_VIEW_PATH] and [RELATIVE_SCREEN_PATH].
  Future<void> setUpDirectories() async {
    if (!isSetUp) {
      _screenDirectoryPath = '${GENERATED_PROJECT_PATH}${RELATIVE_SCREEN_PATH}';
      _viewDirectoryPath = '${GENERATED_PROJECT_PATH}${RELATIVE_VIEW_PATH}';
      _pbProject.forest.forEach((dir) {
        if (dir.rootNode != null) {
          _addImportsInfo(dir);
        }
      });
      Directory(_screenDirectoryPath).createSync(recursive: true);
      Directory(_viewDirectoryPath).createSync(recursive: true);
      isSetUp = true;
    }
  }

  ///Add the import information to correctly generate them in the corresponding files.
  void _addImportsInfo(PBIntermediateTree directory) {
    var intermediateItem = directory;
    // Add to cache if node is scaffold or symbol master
    var node = intermediateItem.rootNode;
    var name = node?.name?.snakeCase;
    if (name != null) {
      var uuid = node is PBSharedMasterNode ? node.SYMBOL_ID : node.UUID;
      var path = node is PBSharedMasterNode
          ? '${_viewDirectoryPath}${directory.name.snakeCase}/${name}.dart' // Removed .g
          : '${_screenDirectoryPath}${directory.name.snakeCase}/${name}.dart';
      PBGenCache().addToCache(uuid, path);
    } else {
      logger.warning(
          'The following intermediateNode was missing a name: ${intermediateItem.toString()}');
    }
  }

  ///Writig the code to the actual file
  ///
  ///The default computation of the function will foward the `code` to the
  ///`_pageWriter`. The [PBPageWriter] will then generate the file with the code inside
  Future<void> generatePage(String code, String fileName, {var args}) {
    if (args is String) {
      var path = args == 'SCREEN'
          ? '${_screenDirectoryPath}${fileName}.dart'
          : '${_viewDirectoryPath}${fileName}.dart'; // Removed .g
      pageWriter.write(code, path);
    }
    return Future.value();
  }
}
