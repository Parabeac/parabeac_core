import 'package:parabeac_core/eggs/injected_app_bar.dart';
import 'package:parabeac_core/eggs/injected_tab_bar.dart';
import 'package:parabeac_core/generation/prototyping/pb_dest_holder.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_gen_cache.dart';

class ImportHelper {
  /// Traverse the [node] tree, check if any nodes need importing,
  /// and add the relative import from [path] to the [node]
  static List<String> findImports(PBIntermediateNode node, String path) {
    List<String> imports = [];
    if (node == null) return imports;

    String id;
    if (node is PBSharedInstanceIntermediateNode) {
      id = node.SYMBOL_ID;
    } else if (node is PBDestHolder) {
      id = node.pNode.destinationUUID;
    } else {
      id = node.UUID;
    }

    var nodePath = PBGenCache().getPath(id);
    // Make sure nodePath exists and is not the same as path (importing yourself)
    if (nodePath != null && nodePath.isNotEmpty && path != nodePath) {
      imports.add(PBGenCache().getRelativePath(path, id));
    }

    // Recurse through child/children and add to imports
    if (node is PBLayoutIntermediateNode) {
      node.children
          .forEach((child) => imports.addAll(findImports(child, path)));
    } else if (node is InheritedScaffold) {
      imports.addAll(findImports(node.navbar, path));
      imports.addAll(findImports(node.tabbar, path));
      imports.addAll(findImports(node.child, path));
    } else if (node is InjectedNavbar) {
      imports.addAll(findImports(node.leadingItem, path));
      imports.addAll(findImports(node.middleItem, path));
      imports.addAll(findImports(node.trailingItem, path));
    } else if (node is InjectedTabBar) {
      for (var tab in node.tabs) {
        imports.addAll(findImports(tab, path));
      }
    } else {
      imports.addAll(findImports(node.child, path));
    }

    return imports.toSet().toList(); // Prevent repeated entries
  }
}
