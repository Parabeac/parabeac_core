import 'package:parabeac_core/generation/flutter_project_builder/flutter_project_builder.dart';
import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/global_styling/colors_post_gen_task.dart';
import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/global_styling/text_styles_post_gen_task.dart';
import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/global_styling/theming_post_gen_task.dart';
import 'package:pbdl/pbdl.dart';
import 'package:recase/recase.dart';

class GlobalStylingAggregator {
  /// List of all supported TextStyles that should be exported
  /// for the deeper theming integration
  static const _textStyleList = [
    'bodyLarge',
    'bodyMedium',
    'bodySmall',
    'bodyText1',
    'bodyText2',
    'button',
    'caption',
    'displayLarge',
    'displayMedium',
    'displaySmall',
    'headline1',
    'headline2',
    'headline3',
    'headline4',
    'headline5',
    'headline6',
    'headlineLarge',
    'headlineMedium',
    'headlineSmall',
    'labelLarge',
    'labelMedium',
    'labelSmall',
    'overline',
    'subtitle1',
    'subtitle2',
    'titleLarge',
    'titleMedium',
    'titleSmall',
  ];

  /// Examines [globalStyles] and adds PostGenTasks to [builder]
  static void addPostGenTasks(
      FlutterProjectBuilder builder, PBDLGlobalStyles globalStyles) {
    if (globalStyles.colors != null && globalStyles.colors.isNotEmpty) {
      builder.postGenTasks.add(
        ColorsPostGenTask(
          builder.generationConfiguration,
          globalStyles.colors,
        ),
      );
    }

    if (globalStyles.textStyles != null && globalStyles.textStyles.isNotEmpty) {
      builder.postGenTasks.add(
        TextStylesPostGenTask(
          builder.generationConfiguration,
          globalStyles.textStyles,
        ),
      );
    }

    var themeTextStyles = <PBDLGlobalTextStyle>[];

    for (var style in globalStyles.textStyles) {
      if (_textStyleList.contains(style.name.camelCase)) {
        /// Add Text Style to Global theming list
        themeTextStyles.add(style);
      }
    }

    if (themeTextStyles.isNotEmpty) {
      /// Add Theme Styles to the Theme task
      builder.postGenTasks.add(
        ThemingPostGenTask(
          builder.generationConfiguration,
          themeTextStyles,
        ),
      );
    }
  }
}
