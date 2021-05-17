import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/write_screen_command.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_project.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_platform_orientation_linker_service.dart';
import 'package:recase/recase.dart';

mixin PBPlatformOrientationGeneration {
  void generatePlatformInstance(Map<String, List<String>> platformsMap,
      String screenName, PBProject mainTree) {
    var formatedName = screenName.snakeCase.toLowerCase();
    if (platformsMap.length > 1) {
      mainTree.genProjectData.commandQueue.add(WriteScreenCommand(
        formatedName + '_platform_builder.dart',
        formatedName,
        _getPlatformInstance(platformsMap, screenName),
      ));
    }
  }

  String _getPlatformInstance(
      Map<String, List<String>> platformsMap, String screenName) {
    var className = screenName.pascalCase;
    // TODO: add dynamic imports
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
      var nameWithPlatform = className + platform.titleCase;
      if (value.length > 1) {
        result += '''
        ${platform}Widget: ResponsiveOrientationBuilder(
        verticalPage: ${nameWithPlatform}Vertical(),
        horizontalPage: ${nameWithPlatform}Horizontal(),
        ),
        ''';
      } else {
        result += '${platform}Widget: ${nameWithPlatform}(),';
      }
    });
    return result;
  }

  void getPlatformOrientationName(PBIntermediateNode node) {
    var map = PBPlatformOrientationLinkerService()
        .getPlatformOrientationData(node.name);

    if (map.length > 1) {
      var platform = PBPlatformOrientationLinkerService()
          .stripPlatform(node.currentContext.tree.data.platform);
      node.name += '_$platform';
    }
    if (map[node.currentContext.tree.data.platform].length > 1) {
      var orientation = PBPlatformOrientationLinkerService()
          .stripOrientation(node.currentContext.tree.data.orientation);
      node.name += '_$orientation';
    }
  }
}
