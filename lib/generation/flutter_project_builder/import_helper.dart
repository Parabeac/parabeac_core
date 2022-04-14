import 'package:parabeac_core/generation/flutter_project_builder/file_writer_observer.dart';
import 'package:path/path.dart' as p;
import 'package:quick_log/quick_log.dart';
import 'package:recase/recase.dart';

class ImportHelper implements FileWriterObserver {
  final Map<String, Set<String>> imports = {};
  final Set<String> _importBaseNames = {};
  final Logger _logger = const Logger('ImportHelper');

  /// Traverse the [node] tree, check if any nodes need importing,
  /// and add the relative import from [path] to the [node]

  // static Set<String> findImports(PBIntermediateNode node, String path) {
  //   Set currentImports = <String>{};
  //   if (node == null) {
  //     return currentImports;
  //   }

  //   String id;
  //   if (node is PBSharedInstanceIntermediateNode) {
  //     id = node.SYMBOL_ID;
  //   } else if (node is PBDestHolder) {
  //     id = node.pNode.destinationUUID;
  //   } else {
  //     id = node.UUID;
  //   }

  //   var nodePaths = PBGenCache().getPaths(id);
  //   // Make sure nodePath exists and is not the same as path (importing yourself)
  //   if (nodePaths != null &&
  //       nodePaths.isNotEmpty &&
  //       !nodePaths.any((element) => element == path)) {
  //     var paths = PBGenCache().getRelativePath(path, id);
  //     paths.forEach(currentImports.add);
  //   }

  //   node.attributes.forEach((attribute) {
  //     attribute.attributeNodes.forEach((attributeNode) {
  //       currentImports.addAll(findImports(attributeNode, path));
  //     });
  //   });

  //   return currentImports;
  // }

  List<String> getImport(String UUID) {
    if (imports.containsKey(UUID)) {
      return imports[UUID].toList();
    }
    return null;
  }

  List getFormattedImports(String UUID,
      {dynamic Function(String import) importMapper}) {
    importMapper ??= (String path) => path;
    return getImport(UUID)?.map(importMapper)?.toList() ?? [];
  }

  /// Returns whether a file with the same [basename] as `import`, but with different [path] exists.
  ///
  /// This is done to alert the user that there may be conflicting imports.
  /// For example, if we have file `page_1/widget.dart` and file `page_2/widget.dart`,
  /// this method will return `true`.
  bool conflictsWithExistingImport(String import) {
    return _importBaseNames.any((element) =>
        p.basename(element) == p.basename(import) && element != import);
  }

  /// Adding [import] to the [imports], allowing other callers to lookup their dependencies using
  /// their [UUID].
  ///
  /// Multiple [import]s could be added under the same [UUID]. This is to allow the
  /// callers of [addImport] to add additional imports for other packages or files that are
  /// certain to be required.
  ////// The only contrain is that the [import] basename need to be
  ////// unique across all [imports], if its not, its not going to be added to the [imports]. For example,
  ////// when we [addImport] `<path>/example.dart`, then `<another-path>/example.dart`, only
  ////// the `<path>/example.dart` is going to be recorded in [imports].
  void addImport(String import, String UUID) {
    if (conflictsWithExistingImport(import)) {
      _logger.warning(
          'A different file with the basename `${p.basename(import)}` has already been added. This will cause import conflicts in certain cases. Make sure your elements are uniquely named and correctly referenced.');
    }
    if (import != null && UUID != null) {
      imports[UUID] ??= {};
      imports[UUID].add(import);
      _importBaseNames.add(import);
    }
  }

  @override
  void fileCreated(String filePath, String fileUUID) =>
      addImport(filePath, fileUUID);

  static String getName(String name) {
    var index = name.indexOf('/');
    // Remove everything after the /. So if the name is SignUpButton/Default, we end up with SignUpButton as the name we produce.
    return index < 0
        ? name
        : name.replaceRange(index, name.length, '').pascalCase;
  }
}
