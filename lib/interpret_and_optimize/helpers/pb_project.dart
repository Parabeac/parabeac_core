import 'package:parabeac_core/generation/generators/util/pb_generation_project_data.dart';
import 'package:parabeac_core/generation/generators/util/pb_generation_view_data.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_platform_orientation_linker_service.dart';
import 'package:quick_log/quick_log.dart';

part 'pb_project.g.dart';

@JsonSerializable(explicitToJson: true)
class PBProject {
  @JsonKey(name: 'name')
  final String projectName;
  String projectAbsPath;

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
  @JsonKey(ignore: true)
  bool get lockData => _lockData;
  set lockData(lock) {
    _lockData = lock;
    _forest.forEach((tree) => tree.lockData = lock);
  }

  List<PBIntermediateTree> _forest;
  @JsonKey(fromJson: PBProject.forestFromJson, name: 'pages')
  List<PBIntermediateTree> get forest => _forest;
  @JsonKey(fromJson: PBProject.forestFromJson, name: 'pages')
  set forest(List<PBIntermediateTree> forest) {
    if (!lockData) {
      _forest = forest;
    }
  }

  @Deprecated(
      'Use the fileStructureStrategy within the GenerationConfiguration')
  FileStructureStrategy _fileStructureStrategy;
  PBGenerationProjectData _genProjectData;

  set genProjectData(PBGenerationProjectData projectData) =>
      _genProjectData = projectData;
  @JsonKey(ignore: true)
  PBGenerationProjectData get genProjectData => _genProjectData;

  @Deprecated(
      'Use the fileStructureStrategy within the GenerationConfiguration')
  set fileStructureStrategy(FileStructureStrategy strategy) =>
      _fileStructureStrategy = strategy;

  @Deprecated(
      'Use the fileStructureStrategy within the GenerationConfiguration')
  @JsonKey(ignore: true)
  FileStructureStrategy get fileStructureStrategy => _fileStructureStrategy;

  @JsonKey(ignore: true)
  static Logger log = Logger('PBProject');

  PBProject(this.projectName, this.projectAbsPath,
      {FileStructureStrategy fileStructureStrategy}) {
    _forest = [];
    _genProjectData = PBGenerationProjectData();
    _fileStructureStrategy = fileStructureStrategy;
    _genProjectData = PBGenerationProjectData();
  }

  factory PBProject.fromJson(Map<String, dynamic> json) =>
      _$PBProjectFromJson(json);

  Map<String, dynamic> toJson() => _$PBProjectToJson(this);

  /// Maps JSON pages to a list of [PBIntermediateTree]
  static List<PBIntermediateTree> forestFromJson(
      List<Map<String, dynamic>> pages) {
    var trees = <PBIntermediateTree>[];
    pages.forEach((page) {
      var screens = (page['screens'] as Iterable).map((screen) {
        // Generate Intermedite tree
        var tree = PBIntermediateTree.fromJson(screen)..name = page['name'];
        tree.generationViewData = PBGenerationViewData();

        if (tree != null) {
          PBProject.log.fine(
              'Processed \'${tree.name}\' in page \'${tree.identifier}\' with item type: \'${tree.tree_type}\'');
        }
        return tree;
      }).toList();
      trees.addAll(screens);
    });

    return trees;
  }
}
