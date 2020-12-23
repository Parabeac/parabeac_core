import 'dart:io';
import 'dart:convert';
import 'package:recase/recase.dart';
import 'package:parabeac_core/generation/generators/pb_page_writer.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_gen_cache.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';

///Responsible for creating a particular file structure depending in the structure
///
///For example, in the provider strategy, there would be a directory for the models and the providers,
///while something like BLoC will assign a directory to a single
abstract class FileStructureStrategy {
  final String _genProjectPath;
  final PBPageWriter _pageWriter;
  final PBIntermediateTree _projectIntermediateTree;
  FileStructureStrategy(
      this._genProjectPath, this._pageWriter, this._projectIntermediateTree);

  Future<void> initializeProject() async {
    var projectName = _projectIntermediateTree.projectName;
    for (var directory in _projectIntermediateTree.groups) {
      var directoryName = directory.name;
      var screenDirectoryName =
          '${_genProjectPath}/lib/screens/${directoryName}';
      var viewDirectoryName = '${_genProjectPath}/lib/views/${directoryName}';

      /// Establish Directories where needed.
      if (directory.items.isNotEmpty) {
        for (var i = 0; i < directory.items.length; i++) {
          var containsScreens = false;
          var containsViews = false;
          if (directory.items[i].node is InheritedScaffold &&
              !containsScreens) {
            containsScreens = true;
            await Directory(screenDirectoryName).create(recursive: true);
          }
          if (directory.items[i].node is PBSharedMasterNode && !containsViews) {
            containsViews = true;
            await Directory(viewDirectoryName).create(recursive: true);
          }
          if (containsScreens && containsViews) {
            continue;
          }
        }
      }

      /// Add import Info.
      for (var intermediateItem in directory.items) {
        // Add to cache if node is scaffold or symbol master
        if (intermediateItem.node is InheritedScaffold) {
          PBGenCache().addToCache(intermediateItem.node.UUID,
              '${screenDirectoryName}/${intermediateItem.node.name.snakeCase}.dart');
        } else if (intermediateItem.node is PBSharedMasterNode) {
          PBGenCache().addToCache(
              (intermediateItem.node as PBSharedMasterNode).SYMBOL_ID,
              '${viewDirectoryName}/${intermediateItem.node.name.snakeCase}.g.dart');
        } else {
          PBGenCache().addToCache(intermediateItem.node.UUID,
              '${screenDirectoryName}/${intermediateItem.node.name.snakeCase}.g.dart');
        }
      }
    }
  }

  Future<void> generatePage(String code, String fileName, {var args});
}

class ProviderFileStructureStrategy extends FileStructureStrategy {
  ProviderFileStructureStrategy(String genProjectPath, PBPageWriter pageWriter,
      PBIntermediateTree projectIntermediateTree)
      : super(genProjectPath, pageWriter, projectIntermediateTree);

  @override
  Future<void> generatePage(String code, String fileName, {args}) {}
}

class FlutterFileStructureStrategy extends FileStructureStrategy {
  FlutterFileStructureStrategy(String genProjectPath, PBPageWriter pageWriter,
      PBIntermediateTree projectIntermediateTree)
      : super(genProjectPath, pageWriter, projectIntermediateTree);

  @override
  Future<void> generatePage(String code, String fileName, {args}) {}
}
