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
    /// Check whether there are theme or global colors
    if ((globalStyles.colors != null && globalStyles.colors.isNotEmpty) ||
        (globalStyles.themeColors != null &&
            globalStyles.themeColors.isNotEmpty)) {
      /// Aggregate all colors
      final globalColors = globalStyles.colors
        ..addAll(globalStyles.themeColors);
      builder.postGenTasks.add(
        ColorsPostGenTask(
          builder.generationConfiguration,
          globalColors,
        ),
      );
    }

    /// Check whether there are theme or global textstyles
    if ((globalStyles.textStyles != null &&
            globalStyles.textStyles.isNotEmpty) ||
        (globalStyles.themeTextStyles != null &&
            globalStyles.themeTextStyles.isNotEmpty)) {
      final globalTextStyles = globalStyles.textStyles
        ..addAll(globalStyles.themeTextStyles);
      builder.postGenTasks.add(
        TextStylesPostGenTask(
          builder.generationConfiguration,
          globalTextStyles,
        ),
      );
    }

    if (globalStyles.themeTextStyles.isNotEmpty ||
        globalStyles.themeColors.isNotEmpty) {
      /// Add Theme Styles to the Theme task
      builder.postGenTasks.add(
        ThemingPostGenTask(
          builder.generationConfiguration,
          globalStyles.themeTextStyles ?? [],
          globalStyles.themeColors ?? [],
        ),
      );
    }
  }
}
