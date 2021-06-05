import 'package:parabeac_core/eggs/injected_app_bar.dart';
import 'package:parabeac_core/eggs/injected_tab_bar.dart';
import 'package:parabeac_core/generation/prototyping/pb_dest_holder.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_gen_cache.dart';
import 'package:parabeac_core/generation/flutter_project_builder/file_writer_observer.dart';
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';

class ImportHelper implements FileWriterObserver {
  final Map<String, Set<String>> imports = {};
  final List<String> _importBaseNames = [];

  /// Traverse the [node] tree, check if any nodes need importing,
  /// and add the relative import from [path] to the [node]
  static Set<String> findImports(PBIntermediateNode node, String path) {
    Set currentImports = <String>{};
    if (node == null) {
      return currentImports;
    }

    String id;
    if (node is PBSharedInstanceIntermediateNode) {
      id = node.SYMBOL_ID;
    } else if (node is PBDestHolder) {
      id = node.pNode.destinationUUID;
    } else {
      id = node.UUID;
    }

    var nodePaths = PBGenCache().getPaths(id);
    // Make sure nodePath exists and is not the same as path (importing yourself)
    if (nodePaths != null &&
        nodePaths.isNotEmpty &&
        !nodePaths.any((element) => element == path)) {
      var paths = PBGenCache().getRelativePath(path, id);
      paths.forEach(currentImports.add);
    }

    // Recurse through child/children and add to imports
    if (node is PBLayoutIntermediateNode) {
      node.children
          .forEach((child) => currentImports.addAll(findImports(child, path)));
    } else if (node is InheritedScaffold) {
      currentImports.addAll(findImports(node.navbar, path));
      currentImports.addAll(findImports(node.tabbar, path));
      currentImports.addAll(findImports(node.child, path));
    } else if (node is InjectedAppbar) {
      currentImports.addAll(findImports(node.leadingItem, path));
      currentImports.addAll(findImports(node.middleItem, path));
      currentImports.addAll(findImports(node.trailingItem, path));
    } else if (node is InjectedTabBar) {
      for (var tab in node.tabs) {
        currentImports.addAll(findImports(tab, path));
      }
    } else {
      currentImports.addAll(findImports(node.child, path));
    }

    return currentImports;
  }

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

  /// Looks that we are not tracking the file in the imports by comparing the
  /// [import]s basename with the collection of [_importBaseNames].
  bool containsBaseName(String import) {
    return _importBaseNames.contains(p.basename(import));
  }

  /// Adding [import] to the [imports], allowing other callers to lookup their dependencies using
  /// their [UUID].
  ///
  /// Multiple [import]s could be added under the same [UUID]. This is to allow the
  /// callers of [addImport] to add additional imports for other packages or files that are
  /// certain to be required. The only contrain is that the [import] basename need to be
  /// unique across all [imports], if its not, its not going to be added to the [imports]. For example,
  /// when we [addImport] `<path>/example.dart`, then `<another-path>/example.dart`, only
  /// the `<path>/example.dart` is going to be recorded in [imports].
  void addImport(String import, String UUID) {
    if (import != null && UUID != null && !containsBaseName(import)) {
      imports[UUID] ??= {};
      imports[UUID].add(import);
      _importBaseNames.add(p.basename(import));
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
