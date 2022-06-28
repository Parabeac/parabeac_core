import 'package:get_it/get_it.dart';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/post_gen_task.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/add_constant_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/file_ownership_policy.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/path_services/path_service.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/pb_generation_configuration.dart';
import 'package:pbdl/pbdl.dart';
import 'package:recase/recase.dart';
import 'package:uuid/uuid.dart';

class ThemingPostGenTask extends PostGenTask {
  GenerationConfiguration generationConfiguration;
  List<PBDLGlobalTextStyle> textStyles;

  List<PBDLGlobalColor> colors;

  ThemingPostGenTask(
    this.generationConfiguration,
    this.textStyles,
  );

  @override
  void execute() {
    final projectName = MainInfo().projectName;

    /// Map the [TextStyle] attributes in the project for [TextTheme]
    final textThemeAttributes = textStyles
        .map((style) =>
            '${style.name}: ${projectName.pascalCase}TextStyles.${style.name},')
        .join();
    final textThemeBoilerplate = 'TextTheme($textThemeAttributes)';

    final textConstant = ConstantHolder(
      'TextTheme',
      'textTheme',
      textThemeBoilerplate,
    );

    var pathService = GetIt.I.get<PathService>();

    /// Imports for material and the [TextStyles].
    var imports = '''
import 'package:flutter/material.dart';
import 'package:${projectName.snakeCase}/${pathService.themingRelativePath.replaceFirst('lib/', '')}/${projectName.snakeCase}_text_styles.g.dart';
''';

    generationConfiguration.fileStructureStrategy.commandCreated(
      WriteConstantsCommand(
        Uuid().v4(),
        [textConstant],
        filename: '${projectName.snakeCase}_theme',
        ownershipPolicy: FileOwnership.PBC,
        imports: imports,
        relativePath: pathService.themingRelativePath,
      ),
    );
  }
}
