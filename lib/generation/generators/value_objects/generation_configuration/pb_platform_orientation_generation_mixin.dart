import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/node_file_structure_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/write_screen_command.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_gen_cache.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_project.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_platform_orientation_linker_service.dart';
import 'package:recase/recase.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

mixin PBPlatformOrientationGeneration {
  NodeFileStructureCommand generatePlatformInstance(
      Map<String, List<String>> platformsMap,
      String screenName,
      PBProject mainTree,
      Set<String> rawImports) {
    var formatedName = screenName.snakeCase.toLowerCase();
    var cookedImports = _cookImports(
        rawImports,
        p.join(
          mainTree.fileStructureStrategy.GENERATED_PROJECT_PATH +
              WriteScreenCommand.SCREEN_PATH +
              '/$formatedName' +
              '/${formatedName}_platform_builder.dart',
        ));
    if (platformsMap.length > 1) {
      return WriteScreenCommand(
        Uuid().v4(),
        formatedName + '_platform_builder.dart',
        formatedName,
        _getPlatformInstance(platformsMap, screenName, cookedImports),
      );
    } else {
      return null;
    }
  }

  String _getPlatformInstance(Map<String, List<String>> platformsMap,
      String screenName, Set<String> cookedImports) {
    var className = screenName.pascalCase;
    return '''
    import 'package:flutter/material.dart';
    import '../../widgets/responsive_layout_builder.dart';
    ${_serveImports(cookedImports)}

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

  Set<String> _cookImports(Set<String> rawImports, String possiblePath) {
    var result = <String>{};
    rawImports.forEach((import) {
      if (possiblePath != null && import != null) {
        result.add(PBGenCache().getRelativePathFromPaths(possiblePath, import));
      }
    });
    return result;
  }

  String _serveImports(Set<String> cookedImports) {
    var result = '';
    cookedImports.forEach((import) {
      result += 'import \'${import}\';\n';
    });
    return result;
  }
}
