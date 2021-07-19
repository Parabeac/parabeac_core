import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/generation/generators/util/pb_generation_view_data.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_linker_service.dart';
import 'package:parabeac_core/input/helper/design_project.dart';
import 'package:parabeac_core/input/helper/design_page.dart';
import 'package:parabeac_core/input/helper/design_screen.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_configuration.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_project.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_alignment_generation_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_constraint_generation_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_generation_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_layout_generation_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_platform_orientation_linker_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_plugin_control_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_symbol_linker_service.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_visual_generation_service.dart';
import 'package:quick_log/quick_log.dart';

class Interpret {
  var log = Logger('Interpret');

  Interpret._internal();

  static final Interpret _interpret = Interpret._internal();

  factory Interpret() {
    return _interpret;
  }

  PBProject _pb_project;
  PBSymbolLinkerService _pbSymbolLinkerService;
  PBPrototypeLinkerService _pbPrototypeLinkerService;
  PBConfiguration configuration;

  void init(String projectName, PBConfiguration configuration) {
    this.configuration ??= configuration;
    log = Logger(runtimeType.toString());
    _interpret._pbSymbolLinkerService = PBSymbolLinkerService();
    _interpret._pbPrototypeLinkerService = PBPrototypeLinkerService();
  }

  Future<PBProject> interpretAndOptimize(
      DesignProject tree, String projectName, String projectPath) async {
    _pb_project = PBProject(projectName, projectPath, tree.sharedStyles);

    ///3rd Party Symbols
    if (tree.miscPages != null) {
      for (var i = 0; i < tree.miscPages?.length; i++) {
        _pb_project.forest
            .addAll((await _generateIntermediateTree(tree.miscPages[i])));
      }
    }

    /// Main Pages
    if (tree.pages != null) {
      for (var i = 0; i < tree.pages?.length; i++) {
        _pb_project.forest
            .addAll((await _generateIntermediateTree(tree.pages[i])));
      }
    }

    return _pb_project;
  }

  /// Taking a design page, returns a PBIntermediateTree verison of it
  Future<Iterable<PBIntermediateTree>> _generateIntermediateTree(
      DesignPage designPage) async {
    var tempForest = <PBIntermediateTree>[];
    var pageItems = designPage.getPageItems();
    for (var i = 0; i < pageItems.length; i++) {
      var tree = await _generateScreen(pageItems[i]);
      if (tree != null && tree.rootNode != null) {
        tree.name = designPage.name;

        tree.data = PBGenerationViewData();
        if (tree.isScreen()) {
          PBPlatformOrientationLinkerService()
              .addOrientationPlatformInformation(tree);
        }

        if (tree != null) {
          log.fine(
              'Processed \'${tree.name}\' in group \'${designPage.name}\' with item type: \'${tree.tree_type}\'');

          tempForest.add(tree);
        }
      }
    }
    return tempForest;
  }

  Future<PBIntermediateTree> _generateScreen(DesignScreen designScreen) async {
    var currentContext = PBContext(configuration);
    currentContext.project = _pb_project;

    var aitServices = [
      PBVisualGenerationService().getIntermediateTree,
      PBSymbolLinkerService(),
      PBPluginControlService(),
      PBLayoutGenerationService(),
      PBConstraintGenerationService(),
      PBAlignGenerationService()
    ];

    var builder =
        AITServiceBuilder(currentContext, designScreen.designNode, aitServices);
    return builder.build();
  }
}

class AITServiceBuilder {
  Logger log;

  PBIntermediateTree _intermediateTree;
  set intermediateTree(PBIntermediateTree tree) => _intermediateTree = tree;

  final PBContext _context;
  Stopwatch _stopwatch;

  /// These are the [AITHandler]s that are going to be transforming
  /// the [_intermediateTree].
  final List _transformations = [];

  final DesignNode designNode;

  AITServiceBuilder(this._context, this.designNode, [List transformations]) {
    log = Logger(runtimeType.toString());
    _stopwatch = Stopwatch();

    if (transformations != null) {
      transformations.forEach(addTransformation);
      if (_verifyTransformationsFailed()) {
        throw Error();
      }
    }
  }

  AITServiceBuilder addTransformation(transformation) {
    if (transformation is AITHandler) {
      _transformations.add(transformation.handleTree);
    } else if (transformation is AITNodeTransformation || transformation is PBDLConversion) {
      _transformations.add(transformation);
    } 
    return this;
  }

  /// Verifies that only the allows data types are within the [_transformations]
  bool _verifyTransformationsFailed() {
    return _transformations.any((transformation) =>
        transformation is! AITHandler &&
        transformation is! AITNodeTransformation &&
        transformation is! PBDLConversion &&
        transformation is! AITTransformation);
  }

  Future<PBIntermediateTree> _pbdlConversion(PBDLConversion conversion) async {
    try {
      _stopwatch.start();
      log.fine('Converting ${designNode.name} to AIT');
      _intermediateTree = await conversion(designNode, _context);
      _context.tree = _intermediateTree;
      _stopwatch.stop();
      log.fine(
          'Finished with ${designNode.name} (${_stopwatch.elapsedMilliseconds}');
      return _intermediateTree;
    } catch (e) {
      MainInfo().captureException(e);
      log.error('PBDL Conversion was not possible');

      /// Exit from Parabeac-Core
      throw Error();
    }
  }

  Future<PBIntermediateTree> build() async {
    var pbdlConversion = _transformations
        .firstWhere((transformation) => transformation is PBDLConversion);
    if (pbdlConversion == null) {
      throw Error();
    }
    _transformations.removeWhere((element) => element is PBDLConversion);
    await _pbdlConversion(pbdlConversion);

    for (var transformation in _transformations) {
      var name = transformation.toString();
      _stopwatch.start();
      log.fine('Started running $name...');
      try {
        if (transformation is AITNodeTransformation) {
          for (var node in _intermediateTree) {
            node = await transformation(_context, node);
          }
        } else if (transformation is AITTransformation) {
          _intermediateTree = await transformation(_context, _intermediateTree);
        }
      } catch (e) {
        MainInfo().captureException(e);
        log.error('${e.toString()} at $name');
      } finally {
        _stopwatch.stop();
        log.fine('stoped running $name (${_stopwatch.elapsed.inMilliseconds})');
      }
    }
    return _intermediateTree;
  }
}
