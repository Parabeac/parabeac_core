import 'dart:collection';

import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/semi_constant_templates/semi_constant_template.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_platform_linker_service.dart';

class ResponsiveLayoutBuilderTemplate implements SemiConstantTemplate {
  @override
  String generateTemplate() {
    var platforms = PBPlatformOrientationLinkerService()
        .platforms
        .map((platform) => platform.toString().split('.').last.toLowerCase());
    var widgetVars = _generatePlatformWidgets(platforms);
    var widgetInit = _generatePlatformInitializers(platforms);
    var breakpointChecks = _generateBreakpointStatements(platforms);
    return '''
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
    Map<String, int> breakpoints = MainInfo().configurations['breakpoints'];
    var sortedMap = SplayTreeMap<String, int>.from(
        breakpoints, (a, b) => breakpoints[a].compareTo(breakpoints[b]));

    var result = '';
    for (var i; i < platforms.length; i++) {
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
