import 'package:parabeac_core/generation/flutter_project_builder/flutter_project_builder.dart';
import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/global_styling/colors_post_gen_task.dart';
import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/global_styling/text_styles_post_gen_task.dart';
import 'package:pbdl/pbdl.dart';

class GlobalStylingAggregator {
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
  }
}
