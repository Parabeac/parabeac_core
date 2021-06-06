import 'package:parabeac_core/generation/generators/util/pb_generation_project_data.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';
import 'package:parabeac_core/input/sketch/entities/style/shared_style.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';

class PBProject {
  final String projectName;
  final String projectAbsPath;

  /// This flag makes the data in the [PBProject] unmodifiable. Therefore,
  /// if a change is made and [lockData] is `true`, the change is going to be ignored.
  ///
  /// This affects the [forest], based on the value given to [lockData] will make the [forest] either
  /// modifiable or unmodifiable.
  ///
  /// This is a workaround to process where the data needs to be analyzed without any modification done to it.
  /// Furthermore, this is a workaround to the unability of creating a copy of the [PBProject] to prevent
  /// the modifications to the object (https://github.com/dart-lang/sdk/issues/3367). As a result, the [lockData] flag
  /// has to be used to prevent those modification in phases where the data needs to be analyzed but unmodified.
  bool _lockData = false;
  bool get lockData => _lockData;
  set lockData(lock) {
    _lockData = lock;
    _forest.forEach((tree) => tree.lockData = lock);
  }

  List<PBIntermediateTree> _forest;
  List<PBIntermediateTree> get forest => _forest;
  set forest(List<PBIntermediateTree> forest) {
    if (!lockData) {
      _forest = forest;
    }
  }

  List<SharedStyle> sharedStyles = [];
  @Deprecated(
      'Use the fileStructureStrategy within the GenerationConfiguration')
  FileStructureStrategy _fileStructureStrategy;
  PBGenerationProjectData _genProjectData;

  set genProjectData(PBGenerationProjectData projectData) =>
      _genProjectData = projectData;
  PBGenerationProjectData get genProjectData => _genProjectData;

  @Deprecated(
      'Use the fileStructureStrategy within the GenerationConfiguration')
  set fileStructureStrategy(FileStructureStrategy strategy) =>
      _fileStructureStrategy = strategy;

  @Deprecated(
      'Use the fileStructureStrategy within the GenerationConfiguration')
  FileStructureStrategy get fileStructureStrategy => _fileStructureStrategy;

  PBProject(this.projectName, this.projectAbsPath, this.sharedStyles,
      {FileStructureStrategy fileStructureStrategy}) {
    _forest = [];
    _genProjectData = PBGenerationProjectData();
    _fileStructureStrategy = fileStructureStrategy;
    _genProjectData = PBGenerationProjectData();
  }
}
