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
    this.colors,
  );

  @override
  void execute() {
    var pathService = GetIt.I.get<PathService>();

    /// Relative path to theming folder for imports
    final themingRelativePath =
        pathService.themingRelativePath.replaceFirst('lib/', '');

    final projectName = MainInfo().projectName;

    final constants = <ConstantHolder>[];
    final importBuffer = StringBuffer(
      'import \'package:flutter/material.dart\';',
    );

    if (textStyles.isNotEmpty) {
      importBuffer.writeln(
        'import \'package:${projectName.snakeCase}/$themingRelativePath/${projectName.snakeCase}_text_styles.g.dart\';',
      );

      /// Map the [TextStyle] attributes in the project for [TextTheme]
      final textThemeAttributes = textStyles
          .map((style) =>
              '${style.name.camelCase}: ${projectName.pascalCase}TextStyles.${style.name.camelCase},')
          .join();
      final textThemeBoilerplate = 'TextTheme($textThemeAttributes)';

      constants.add(ConstantHolder(
        'TextTheme',
        'textTheme',
        textThemeBoilerplate,
      ));

      /// Only create a [ThemeData] here if there are no [ColorSchemes].
      ///
      /// This is because a [ThemeData] will already be generated for each [ColorSchem]
      if (colors.isEmpty) {
        constants.add(ConstantHolder(
          'ThemeData',
          'themeData',
          'ThemeData(textTheme: textTheme,)',
          isconst: false,
        ));
      }
    }

    if (colors.isNotEmpty) {
      importBuffer.writeln(
        'import \'package:${projectName.snakeCase}/$themingRelativePath/${projectName.snakeCase}_colors.g.dart\';',
      );

      /// Map the [ColorSchemes] by name
      final colorSchemeMap = <String, List<String>>{};
      for (final color in colors) {
        final attributeName = color.name.split('/').last;
        final colorAttribute =
            '$attributeName: ${projectName.pascalCase}Colors.${color.name.camelCase}';
        if (colorSchemeMap.containsKey(color.colorScheme)) {
          colorSchemeMap[color.colorScheme].add(colorAttribute);
        } else {
          colorSchemeMap[color.colorScheme] = [colorAttribute];
        }
      }

      /// Create the constants for [ThemeData] and [ColorSchemes]
      for (final entry in colorSchemeMap.entries) {
        final attributes = entry.value.join(',');
        constants.add(ConstantHolder(
            'ColorScheme', entry.key, 'ColorScheme.${entry.key}($attributes)'));
        constants.add(ConstantHolder(
          'ThemeData',
          'themeData${entry.key.pascalCase}',
          'ThemeData(${textStyles.isNotEmpty ? 'textTheme: textTheme,' : ''} colorScheme: ${entry.key},)',
          isconst: false,
        ));
      }
    }

    generationConfiguration.fileStructureStrategy.commandCreated(
      WriteConstantsCommand(
        Uuid().v4(),
        constants,
        filename: '${projectName.snakeCase}_theme',
        ownershipPolicy: FileOwnership.PBC,
        imports: importBuffer.toString(),
        relativePath: pathService.themingRelativePath,
      ),
    );
  }
}
