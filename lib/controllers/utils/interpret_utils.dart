import 'package:parabeac_core/generation/generators/util/pb_generation_view_data.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

/// Utils that extract platform and orientation from a node.
mixin InterpretUtils {
  /// Extracts and returns platform of the screen.
  ///
  /// Defaults to PLATFORM.MOBILE if no platform is given.
  PLATFORM extractPlatform(String name) {
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
  ORIENTATION extractOrientation(Point bottomRight, Point topLeft) {
    var width = (topLeft.x - bottomRight.x).abs();
    var height = (topLeft.y - bottomRight.y).abs();

    if (height < width) {
      return ORIENTATION.HORIZONTAL;
    }

    return ORIENTATION.VERTICAL;
  }
}
