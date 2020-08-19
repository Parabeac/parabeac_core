import 'dart:convert';
import 'dart:io';

import 'package:parabeac_core/controllers/errors/pre_generation_errors.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_group.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import '../../controllers/main_info.dart';

class IntermediateWriter {
  PBIntermediateTree tree;
  String _ouputDir;
  IntermediateWriter(
    this.tree,
  );

  /// Method that writes a `.json file` containing the [intermediate widgets].
  /// When passed an [outputDir], the `.json file` will be generated at that location,
  /// otherwise it will be generated in the default directory.
  void writeJsonFile(String filename, {String outputDir}) {
    var formattedProjectName = tree.projectName
            .trim()
            .toLowerCase()
            .replaceAll('.sketch', '')
            .replaceAll(' ', '_') +
        '.json';

    var entities = _generateAllPages();
    if (tree.rootItem.node != null) {
      entities['root'] = tree.rootItem.node.toJson();
    } else {
      throw RootItemNotSetError();
    }
    _ouputDir =
        outputDir ?? '${MainInfo().outputPath}/out/${formattedProjectName}';

    var output = File(outputDir != null
        ? _ouputDir
        : '${MainInfo().outputPath}/out/${formattedProjectName}');
    output.createSync(recursive: true);
    output.writeAsStringSync(json.encode(entities));
  }

  String getOutputDir() {
    return _ouputDir;
  }

  /// Creates a map that contains both Symbols
  /// and conventional pages in intermediate
  /// json format ready to be written to a file
  Map _generateAllPages() {
    return {'pages': _generateConventionalPages(tree.groups)};
  }

  /// Generates the conventional pages in json
  /// and return the Map
  List _generateConventionalPages(List<PBIntermediateGroup> groups) {
    var result = [];

    for (var group in groups) {
      var tempMap = <String, dynamic>{
        'name': group.name,
        'screens': [],
        'shared': [],
        'misc': [],
      };

      // Generate screens
      group.items.forEach((screen) {
        if (screen.type == 'SCREEN') {
          tempMap['screens'].add(screen.node.toJson());
        } else if (screen.type == 'SHARED') {
          tempMap['shared'].add(screen.node.toJson());
        } else {
          tempMap['misc'].add(screen.node.toJson());
        }
      });
      // Add page entry to result map
      result.add(tempMap);
    }
    return result;
  }
}
