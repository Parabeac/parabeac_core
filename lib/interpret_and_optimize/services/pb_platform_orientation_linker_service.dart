import 'dart:collection';
import 'package:parabeac_core/controllers/interpret.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:recase/recase.dart';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/add_constant_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/orientation_builder_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/responsive_layout_builder_command.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'dart:math';
import 'package:recase/recase.dart';

class PBPlatformOrientationLinkerService extends AITHandler {
  static final PBPlatformOrientationLinkerService _pbPlatformLinkerService =
      PBPlatformOrientationLinkerService._internal();

  PBPlatformOrientationLinkerService._internal();

  factory PBPlatformOrientationLinkerService() => _pbPlatformLinkerService;

  final Map<String, List<PBIntermediateTree>> _map = {};

  /// Map that shows how many trees with the same name `key` exist.
  final Map<String, int> _mapCounter = {};

  /// Set of all platforms in the project
  final SplayTreeSet<PLATFORM> _platforms =
      SplayTreeSet((a, b) => a.index.compareTo(b.index));

  /// Set of all orientations in the project
  final Set<ORIENTATION> _orientations = {};

  /// Populates [tree]'s platform and orientation information
  /// and adds [tree] to storage.
  void addOrientationPlatformInformation(
      PBIntermediateTree tree, PBContext context) {
    tree.generationViewData.platform = _extractPlatform(tree.platformName);
    tree.generationViewData.orientation = _extractOrientation(
      tree.rootNode.frame.bottomRight,
      tree.rootNode.frame.topLeft,
    );

    _platforms.add(tree.generationViewData.platform);
    _orientations.add(tree.generationViewData.orientation);

    // Add orientation builder template to the project
    // if there are more than 1 orientation on the project
    if (hasMultipleOrientations()) {
      context.configuration.generationConfiguration.commandQueue
          .add(OrientationBuilderCommand(tree.UUID));
    }
    // Add responsive layout builder template to the project
    // if there are more than 1 plataform on the project
    if (hasMultiplePlatforms()) {
      context.configuration.generationConfiguration.commandQueue
          .add(ResponsiveLayoutBuilderCommand(tree.UUID));
      _addBreakpoints(tree, context);
    }

    addToMap(tree);
  }

  /// Adds [tree] to the storage
  void addToMap(PBIntermediateTree tree) {
    var key = tree.identifier;
    if (_map.containsKey(key)) {
      // Check if we have exact trees (same orientation and platform)
      var trees = _map[key];
      for (var currTree in trees) {
        // Ensure we're comparing the same string by converting to snakecase
        var treeName = key.snakeCase;
        var iterTreeName = currTree.rootNode.name.snakeCase;
        if (treeName == iterTreeName &&
            tree.generationViewData.orientation ==
                currTree.generationViewData.orientation &&
            tree.generationViewData.platform ==
                currTree.generationViewData.platform) {
          // Rename the tree if both trees have the same orientation and platform
          tree.rootNode.name = treeName + '_${_mapCounter[iterTreeName]}';
          _mapCounter[treeName]++;
        }
      }

      _map[key].add(tree);
      if (!_mapCounter.containsKey(key)) {
        _mapCounter[key] = 1;
      }
    } else {
      _map[key] = [tree];
      _mapCounter[key] = 1;
    }
  }

  /// Returns the list of [PBIntermediateTree] with matching [name].
  List<PBIntermediateTree> getScreensWithName(String name) {
    if (_map.containsKey(name)) {
      return _map[name];
    }
    return [];
  }

  /// Returns a map containing platform and orientation information for the screen with matching [name].
  ///
  /// Below is an example output of this method:
  /// {
  ///   PLATFORM.MOBILE: {
  ///     ORIENTATION.VERTICAL: PBINTERMEDIATETREE,
  ///     ORIENTATION.HORIZONTAL: PBINTERMEDIATETREE,
  ///   },
  ///   PLATFORM.DESKTOP: {
  ///     ORIENTATION.HORIZONTAL: PBINTERMEDIATETREE,
  ///   }
  /// }
  Map<PLATFORM, Map<ORIENTATION, PBIntermediateTree>>
      getPlatformOrientationData(String name) {
    var result = <PLATFORM, Map<ORIENTATION, PBIntermediateTree>>{};
    if (_map.containsKey(name)) {
      var screens = _map[name];

      for (var screen in screens) {
        // Add orientation to a platform
        if (result.containsKey(screen.generationViewData.platform)) {
          result[screen.generationViewData.platform]
              [screen.generationViewData.orientation] = screen;
        }
        // Create entry for current platform-orientation pair
        else {
          result[screen.generationViewData.platform] = {
            screen.generationViewData.orientation: screen,
          };
        }
      }
    }
    return result;
  }

  /// Returns [true] if any screen has support for more than
  /// one platform. Returns [false] otherwise.
  bool hasMultiplePlatforms() => _platforms.length > 1;

  /// returns [true] if any screen has support for more than
  /// one orientation. Returns [false] otherwise.
  bool hasMultipleOrientations() => _orientations.length > 1;

  /// Returns platforms of the project
  Set<PLATFORM> get platforms => _platforms;

  /// Returns orientations of the project
  Set<ORIENTATION> get orientations => _orientations;

  /// Returns `true` if screen with `name` has more than one platform.
  /// Returns `false` otherwise.
  bool screenHasMultiplePlatforms(String name) =>
      _map.containsKey(name) && _map[name].length > 1;

  /// Removes the `PLATFORM.` prefix from `platform` and returns the stripped platform.
  String stripPlatform(PLATFORM platform) =>
      platform.toString().toLowerCase().replaceFirst('platform.', '');

  /// Removes the `ORIENTATION.` prefix from `orientation` and returns the stripped orientation.
  String stripOrientation(ORIENTATION orientation) =>
      orientation.toString().toLowerCase().replaceFirst('orientation.', '');

  Map<String, Map<String, List<String>>> getWhoNeedsAbstractInstance() {
    var result = <String, Map<String, List<String>>>{};
    _map.forEach((key, value) {
      if (value.length > 1) {
        result[key] = _getPlatformAndOrientation(value);
      }
    });
    return result;
  }

  Map<String, List<String>> _getPlatformAndOrientation(
      List<PBIntermediateTree> list) {
    var result = <String, List<String>>{};
    list.forEach((value) {
      var platform = stripPlatform(value.generationViewData.platform);
      var orientation = stripOrientation(value.generationViewData.orientation);
      if (result.containsKey(platform)) {
        result[platform].add(orientation);
      } else {
        result[platform] = [];
        result[platform].add(orientation);
      }
    });
    return result;
  }

  /// Extracts and returns platform of the screen.
  ///
  /// Defaults to PLATFORM.MOBILE if no platform is given.
  PLATFORM _extractPlatform(String name) {
    var platform = name?.split('/')?.last?.toLowerCase()?.trim() ?? '';
    switch (platform) {
      case 'desktop':
        return PLATFORM.DESKTOP;
      case 'tablet':
        return PLATFORM.TABLET;
      default:
        return PLATFORM.MOBILE;
    }
  }

  /// Extracts orientation based on a node's TLC and BRC points.
  ORIENTATION _extractOrientation(Point bottomRight, Point topLeft) {
    var width = (topLeft.x - bottomRight.x).abs();
    var height = (topLeft.y - bottomRight.y).abs();

    if (height < width) {
      return ORIENTATION.HORIZONTAL;
    }

    return ORIENTATION.VERTICAL;
  }

  void _addBreakpoints(PBIntermediateTree tree, PBContext context) {
    if (MainInfo().configuration.breakpoints != null) {
      var bp = MainInfo().configuration.breakpoints.cast<String, num>();
      var constants = <ConstantHolder>[];
      bp.forEach((key, value) {
        constants.add(ConstantHolder(
          'num',
          '${key}Breakpoint',
          value.toString(),
        ));
      });
      var cmd = WriteConstantsCommand(tree.UUID, constants);
      context.configuration.generationConfiguration.commandQueue.add(cmd);
    }
  }

  @override
  Future<PBIntermediateTree> handleTree(
      PBContext context, PBIntermediateTree tree) {
    addOrientationPlatformInformation(tree, context);
    return Future.value(tree);
  }
}

/// Enum of supported platforms.
///
/// The order of this enum is important, and goes from smallest value to greatest.
enum PLATFORM {
  MOBILE,
  TABLET,
  DESKTOP,
}

enum ORIENTATION {
  HORIZONTAL,
  VERTICAL,
}
