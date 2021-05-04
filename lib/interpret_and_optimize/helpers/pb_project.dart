import 'package:parabeac_core/generation/generators/util/pb_generation_project_data.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy.dart/pb_file_structure_strategy.dart';
import 'package:parabeac_core/input/sketch/entities/style/shared_style.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';

class PBProject {
  String projectName;
  String projectAbsPath;
  List<PBIntermediateTree> forest = [];
  List<SharedStyle> sharedStyles = [];
  FileStructureStrategy _fileStructureStrategy;
  PBGenerationProjectData _genProjectData;

  set genProjectData(PBGenerationProjectData projectData) =>
      _genProjectData = projectData;
  PBGenerationProjectData get genProjectData => _genProjectData;

  set fileStructureStrategy(FileStructureStrategy strategy) =>
      _fileStructureStrategy = strategy;

  FileStructureStrategy get fileStructureStrategy => _fileStructureStrategy;

  PBProject(this.projectName, this.sharedStyles,
      {FileStructureStrategy fileStructureStrategy}) {
    _genProjectData = PBGenerationProjectData();
    _fileStructureStrategy = fileStructureStrategy;
  }

  // Pass through the forest once checking all trees
  // if two or more trees have the same name and same
  // orientation, a `_n` counter is added at the end
  // of their name
  void cleanTreeParity() {
    forest.sort((a, b) => a.rootNode.name.compareTo(b.rootNode.name));
    var currentCounter = 0;
    var nextCounter = currentCounter + 1;
    var nameCounter = 1;

    while (nextCounter < forest.length) {
      var currentTree = forest[currentCounter];
      var nextTree = forest[nextCounter];
      if (currentTree.rootNode.name.compareTo(nextTree.rootNode.name) == 0) {
        if (currentTree.data.orientation == nextTree.data.orientation) {
          forest[nextCounter].rootNode.name =
              forest[nextCounter].rootNode.name + '_$nameCounter';

          nameCounter++;
          nextCounter++;
        } else {
          currentCounter = nextCounter;
          nextCounter++;
        }
      } else {
        currentCounter = nextCounter;
        nextCounter++;
        nameCounter = 1;
      }
    }
  }
}
