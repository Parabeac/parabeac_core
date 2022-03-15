import 'package:parabeac_core/controllers/interpret.dart';
import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/comp_isolation/dashbook/entities/dashbook_book.dart';
import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/comp_isolation/dashbook/entities/dashbook_chapter.dart';
import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/comp_isolation/dashbook/entities/dashbook_story.dart';
import 'package:parabeac_core/generation/generators/attribute-helper/pb_size_helper.dart';
import 'package:parabeac_core/generation/generators/symbols/pb_instancesym_gen.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:recase/recase.dart';

class DashbookService extends AITHandler {
  /// Map that holds the name of the folder as its key, and the folder as its value.

  static Map<String, DashBookStory> _dashBookStories;
  static DashBookBook book = DashBookBook();
  static final treeIds = <String>[];

  DashbookService() {
    _dashBookStories = {};
  }

  @override
  Future<PBIntermediateTree> handleTree(
      PBContext context, PBIntermediateTree tree) async {
    /// Only process [PBSharedMasterNode]s.
    if (tree.rootNode is PBSharedMasterNode) {
      treeIds.add(tree.UUID);

      var component = tree.rootNode as PBSharedMasterNode;
      var rootName = component.componentSetName ?? tree.rootNode.name;

      /// Create new Widget for this variation if it doesn't exist already
      if (!_dashBookStories.containsKey(rootName)) {
        _dashBookStories[rootName] = DashBookStory(rootName);
        book.addChild(_dashBookStories[rootName]);
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
      var useCase = DashBookChapter(
        (tree.rootNode as PBSharedMasterNode).name.pascalCase,
        generatedCode,
      );
      _dashBookStories[rootName].addChild(useCase);
    }
    return tree;
  }
}
