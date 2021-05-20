import 'dart:collection';
import 'package:path/path.dart' as p;
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/file_structure_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_platform_orientation_linker_service.dart';

class ResponsiveLayoutBuilderCommand extends FileStructureCommand {
  static final DIR_TO_RESPONSIVE_LAYOUT = 'lib/widgets/';
  static final NAME_TO_RESPONSIVE_LAYOUT = 'responsive_layout_builder.dart';

  ResponsiveLayoutBuilderCommand(String UUID) : super(UUID);

  @override
  Future write(FileStructureStrategy strategy) async {
    var platforms = PBPlatformOrientationLinkerService()
        .platforms
        .map((platform) => platform.toString().split('.').last.toLowerCase())
        .toList();
    var widgetVars = _generatePlatformWidgets(platforms);
    var widgetInit = _generatePlatformInitializers(platforms);
    var breakpointChecks = _generateBreakpointStatements(platforms);
    //TODO: use imports system to import material. See updated orientation builder command
    var template = '''
    import 'package:flutter/material.dart';
    class ResponsiveLayoutBuilder extends StatelessWidget {
      $widgetVars

      const ResponsiveLayoutBuilder(
        {
          Key key,
          $widgetInit
        }
      );

      @override
      Widget build(BuildContext context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            var width = constraints.maxWidth;
            $breakpointChecks
            return Container();
          },
        );
      }
    }
    ''';

    strategy.writeDataToFile(
      template,
      p.join(strategy.GENERATED_PROJECT_PATH, DIR_TO_RESPONSIVE_LAYOUT),
      NAME_TO_RESPONSIVE_LAYOUT,
      UUID: UUID,
    );
  }

  String _generatePlatformWidgets(List<String> platforms) {
    var result = '';
    platforms.forEach((platform) => result += 'final ${platform}Widget;');
    return result;
  }

  String _generatePlatformInitializers(List<String> platforms) {
    var result = '';
    platforms.forEach((platform) => result += 'this.${platform}Widget,');
    return result;
  }

  String _generateBreakpointStatements(List<String> platforms) {
    if (platforms.length == 1) {
      return 'if(${platforms[0]} != null){return ${platforms[0]}Widget;}';
    }
    // Get breakpoints from configurations and sort by value
    var breakpoints = MainInfo().configurations['breakpoints'];
    if (breakpoints == null) {
      // TODO: Handle breakpoints being null
      breakpoints = {};
      breakpoints['mobile'] = 300;
      breakpoints['tablet'] = 600;
      breakpoints['desktop'] = 1280;
    }
    var sortedMap = SplayTreeMap<String, int>.from(
        breakpoints, (a, b) => breakpoints[a].compareTo(breakpoints[b]));

    var result = '';
    for (var i = 0; i < platforms.length; i++) {
      var platform = platforms[i];
      if (sortedMap.containsKey(platform)) {
        if (i == platforms.length - 1) {
          result += 'if(${platform}Widget != null){return ${platform}Widget;}';
        } else {
          result +=
              'if(${platform}Widget != null && width < ${platforms[i + 1]}Breakpoint) {return ${platform}Widget;}';
        }
      }
    }
    return result;
  }
}
