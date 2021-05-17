import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/write_screen_command.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_project.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_platform_orientation_linker_service.dart';
import 'package:recase/recase.dart';

mixin PBPlatformOrientationGeneration {
  void generatePlatformInstance(Map<String, List<String>> platformsMap,
      String screenName, PBProject mainTree) {
    platformsMap.forEach((platform, screens) {
      var formatedName = screenName.snakeCase.toLowerCase();
      if (screens.length > 1) {
        _generateOrientationInstance(screenName, mainTree);
      }
      if (platformsMap.length > 1) {
        mainTree.genProjectData.commandQueue.add(WriteScreenCommand(
          formatedName + '_platform_builder.dart',
          formatedName,
          _getPlatformInstance(platformsMap, screenName),
        ));
      }
    });
  }

  void _generateOrientationInstance(String screenName, PBProject mainTree) {
    var formatedName = screenName.snakeCase.toLowerCase();
    mainTree.genProjectData.commandQueue.add(WriteScreenCommand(
      formatedName + '_orientation_builder.dart',
      formatedName,
      _getOrientationInstance(screenName),
    ));
  }

  String _getPlatformInstance(
      Map<String, List<String>> platformsMap, String screenName) {
    var className = screenName.pascalCase;
    return '''
    import 'package:flutter/material.dart';
    import '../../widgets/responsive_layout_builder.dart';

    class ${className}PlatformBuilder extends StatelessWidget {
      @override
      Widget build(BuildContext context) {
        return ResponsiveLayoutBuilder(
          ${_getPlatformsWidgets(platformsMap, className)}
        );
      }
    }
    ''';
  }

  String _getPlatformsWidgets(
      Map<String, List<String>> platformsMap, String className) {
    var result = '';
    platformsMap.forEach((platform, value) {
      result += '${platform}Widget: ${className}_$platform(),';
    });
    return result;
  }

  String _getOrientationInstance(String screenName) {
    var className = screenName.pascalCase;
    return '''
    import 'package:flutter/material.dart';
    import '../../widgets/responsive_orientation_builder.dart';

    class ${className}OrientationBuilder extends StatelessWidget {
      @override
      Widget build(BuildContext context) {
        return ResponsiveOrientationBuilder(
          verticalPage: ${className}Vertical(),
          horizontalPage: ${className}Horizontal(),
        );
      }
    }
    ''';
  }

  String getPlatformOrientationName(PBIntermediateNode node) {
    var result = '';
    var map = PBPlatformOrientationLinkerService()
        .getPlatformOrientationData(node.name);

    if (map[node.currentContext.tree.data.platform].length > 1) {
      var orientation = PBPlatformOrientationLinkerService()
          .stripOrientation(node.currentContext.tree.data.orientation);
      result += '_$orientation';
    }

    return result;
  }
}
