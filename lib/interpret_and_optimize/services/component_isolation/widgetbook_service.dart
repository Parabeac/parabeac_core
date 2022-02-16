import 'package:parabeac_core/controllers/interpret.dart';
import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/comp_isolation/widgetbook/entities/widgetbook_category.dart';
import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/comp_isolation/widgetbook/entities/widgetbook_folder.dart';
import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/comp_isolation/widgetbook/entities/widgetbook_use_case.dart';
import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/comp_isolation/widgetbook/entities/widgetbook_widget.dart';
import 'package:parabeac_core/generation/generators/attribute-helper/pb_size_helper.dart';
import 'package:parabeac_core/generation/generators/symbols/pb_instancesym_gen.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:recase/recase.dart';

class WidgetBookService extends AITHandler {
  /// Map that holds the name of the folder as its key, and the folder as its value.

  // FIXME: The reason these are static is because otherwise we'd need a service that can
  // gather the folders, widgets, and categories to pass it to the ComponentIsolationService.
  // The treeIds need to be gathered to generate the imports later on as well.
  static Map<String, WidgetBookFolder> _widgetBookFolders;
  static Map<String, WidgetBookWidget> _widgetBookWidgets;
  static WidgetBookCategory category = WidgetBookCategory();
  static final treeIds = <String>[];

  WidgetBookService() {
    _widgetBookFolders = {};
    _widgetBookWidgets = {};
  }

  @override
  Future<PBIntermediateTree> handleTree(
      PBContext context, PBIntermediateTree tree) async {
    /// Only process [PBSharedMasterNode]s.
    if (tree.rootNode is PBSharedMasterNode) {
      treeIds.add(tree.UUID);

      /// Create a new folder if it doesn't exist.
      if (!_widgetBookFolders.containsKey(tree.name)) {
        _widgetBookFolders[tree.name] = WidgetBookFolder(tree.name);
        category.addChild(_widgetBookFolders[tree.name]);
      }

      var component = tree.rootNode as PBSharedMasterNode;
      var rootName = component.componentSetName ?? tree.rootNode.name;

      /// Create new Widget for this variation if it doesn't exist already
      if (!_widgetBookWidgets.containsKey(rootName)) {
        _widgetBookWidgets[rootName] = WidgetBookWidget(rootName);
        _widgetBookFolders[tree.name].addChild(_widgetBookWidgets[rootName]);
      }

      /// Create a fake instance in order to generate the Use Case.
      // FIXME: Generating the code should happen somewhere in generate, not here.
      var dummyInstance = PBSharedInstanceIntermediateNode(
        null,
        tree.rootNode.frame.copyWith(),
        SYMBOL_ID: component.SYMBOL_ID,
        name: rootName,
        sharedNodeSetID: component.sharedNodeSetID,
      );
      var sizeHelper = PBSizeHelper();

      var generatedCode = '''
      SizedBox(
        ${sizeHelper.generate(dummyInstance, context.copyWith(sizingContext: SizingValueContext.PointValue))}
        child: ${(dummyInstance.generator as PBSymbolInstanceGenerator).generate(
        dummyInstance,
        context.copyWith(),
      )},
      ),
    ''';

      /// Create a use case for the current component and add it to the folder.
      var useCase = WidgetBookUseCase(
        (tree.rootNode as PBSharedMasterNode).name.pascalCase,
        generatedCode,
      );
      _widgetBookWidgets[rootName].addChild(useCase);
    }
    return tree;
  }
}
