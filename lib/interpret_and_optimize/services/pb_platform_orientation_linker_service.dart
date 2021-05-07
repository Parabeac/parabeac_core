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
  final Set<PLATFORM> _platforms = {};

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
    if (hasMultipleOrientations()) {
      tree.rootNode.currentContext.project.genProjectData.commandQueue
          .add(OrientationBuilderCommand());
    }
    // Add responsive layout builder template to the project
    // if there are more than 1 plataform on the project
    if (hasMultiplePlatforms()) {
      tree.rootNode.currentContext.project.genProjectData.commandQueue
          .add(ResponsiveLayoutBuilderCommand());
    }

    addToMap(tree);
  }

  /// Adds [tree] to the storage
  void addToMap(PBIntermediateTree tree) {
    if (_map.containsKey(tree.name)) {
      // Check if we have exact trees (same orientation and platform)
      var trees = _map[tree.name];
      for (var currTree in trees) {
        var treeName = tree.rootNode.name;
        var iterTreeName = currTree.rootNode.name;
        if (treeName == iterTreeName &&
            tree.data.orientation == currTree.data.orientation &&
            tree.data.platform == currTree.data.platform) {
          // Rename the tree if both trees have the same orientation and platform
          tree.rootNode.name = treeName + '_${_mapCounter[tree.rootNode.name]}';
          _mapCounter[treeName]++;
        }
      }

      _map[tree.name].add(tree);
      if (!_mapCounter.containsKey(tree.rootNode.name)) {
        _mapCounter[tree.rootNode.name] = 1;
      }
    } else {
      _map[tree.name] = [tree];
      _mapCounter[tree.rootNode.name] = 1;
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
    var result = {};
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
}

enum PLATFORM {
  DESKTOP,
  MOBILE,
  TABLET,
}

enum ORIENTATION {
  HORIZONTAL,
  VERTICAL,
}
