import 'dart:collection';

import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/file_structure_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_platform_orientation_linker_service.dart';

class ResponsiveLayoutBuilderCommand extends FileStructureCommand {
  final PATH_TO_RESPONSIVE_LAYOUT =
      'lib/widgets/responsive_layout_builder.dart';

  @override
  Future write(FileStructureStrategy strategy) async {
    var absPath =
        '${strategy.GENERATED_PROJECT_PATH}$PATH_TO_RESPONSIVE_LAYOUT';

    var platforms = PBPlatformOrientationLinkerService()
        .platforms
        .map((platform) => platform.toString().split('.').last.toLowerCase())
        .toList();
    var widgetVars = _generatePlatformWidgets(platforms);
    var widgetInit = _generatePlatformInitializers(platforms);
    var breakpointChecks = _generateBreakpointStatements(platforms);
    var template = '''
    class ResponsiveLayoutBuilder extends StatelessWidget {
      ${widgetVars}

      const ResponsiveLayoutBuilder(
        {
          Key key,
          ${widgetInit}
        }
      );

      @override
      Widget build(BuildContext context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            var width = constraints.maxWidth;
            ${breakpointChecks}
            return Container();
          },
        );
      }
    }
    ''';

    super.writeDataToFile(template, absPath);
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