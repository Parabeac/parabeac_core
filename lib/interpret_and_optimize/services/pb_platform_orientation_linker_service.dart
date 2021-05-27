import 'dart:collection';

import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/add_constant_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/orientation_builder_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/responsive_layout_builder_command.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

class PBPlatformOrientationLinkerService {
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
  void addOrientationPlatformInformation(PBIntermediateTree tree) {
    tree.data.platform = _extractPlatform(tree.name);
    tree.data.orientation = _extractOrientation(
      tree.rootNode.bottomRightCorner,
      tree.rootNode.topLeftCorner,
    );

    _platforms.add(tree.data.platform);
    _orientations.add(tree.data.orientation);

    // Add orientation builder template to the project
    // if there are more than 1 orientation on the project
    if (orientations.length == 2) {
      tree.rootNode.currentContext.project.genProjectData.commandQueue
          .add(OrientationBuilderCommand(tree.UUID));
    }
    // Add responsive layout builder template to the project
    // if there are more than 1 platform on the project
    if (platforms.length == 2) {
      tree.rootNode.currentContext.project.genProjectData.commandQueue
          .add(ResponsiveLayoutBuilderCommand(tree.UUID));
      _addBreakpoints(tree);
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
        var treeName = key;
        var iterTreeName = currTree.rootNode.name;
        if (treeName == iterTreeName &&
            tree.data.orientation == currTree.data.orientation &&
            tree.data.platform == currTree.data.platform) {
          // Rename the tree if both trees have the same orientation and platform
          tree.rootNode.name = treeName + '_${_mapCounter[tree.rootNode.name]}';
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
        if (result.containsKey(screen.data.platform)) {
          result[screen.data.platform][screen.data.orientation] = screen;
        }
        // Create entry for current platform-orientation pair
        else {
          result[screen.data.platform] = {
            screen.data.orientation: screen,
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
      var platform = stripPlatform(value.data.platform);
      var orientation = stripOrientation(value.data.orientation);
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

  void _addBreakpoints(PBIntermediateTree tree) {
    if (MainInfo().configurations.containsKey('breakpoints')) {
      Map<String, num> bp =
          MainInfo().configurations['breakpoints'].cast<String, num>();
      bp.forEach((key, value) {
        var cmd = AddConstantCommand(
            tree.UUID, key + 'Breakpoint', 'num', value.toString());
        tree.rootNode.currentContext.project.genProjectData.commandQueue
            .add(cmd);
      });
    }
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
