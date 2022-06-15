import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/post_gen_task.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/add_constant_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/file_ownership_policy.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/pb_generation_configuration.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_text_gen.dart';
import 'package:pbdl/pbdl.dart';
import 'package:recase/recase.dart';
import 'package:uuid/uuid.dart';

/// Class that generates all global [TextStyles] and exports them to a file
class TextStylesPostGenTask extends PostGenTask {
  GenerationConfiguration generationConfiguration;
  List<PBDLGlobalTextStyle> textStyles;

  TextStylesPostGenTask(this.generationConfiguration, this.textStyles);

  @override
  void execute() {
    var constTextStyles = <ConstantHolder>[];
    var mainInfo = MainInfo();

    /// Format text styles to be added to constants file
    textStyles.forEach((globalTextStyle) {
      constTextStyles.add(ConstantHolder(
        'TextStyle',
        globalTextStyle.name.camelCase,
        _textStyleStr(globalTextStyle.textStyle),
        description: globalTextStyle.description,
      ));
    });

    generationConfiguration.fileStructureStrategy.commandCreated(
      WriteConstantsCommand(
        Uuid().v4(),
        constTextStyles,
        filename: '${mainInfo.projectName.snakeCase}_text_styles',
        ownershipPolicy: FileOwnership.PBC,
        imports: 'import \'package:flutter/material.dart\';',
      ),
    );
  }

  // TODO: Abstract so that Text and this use the same TextStyle generator.
  String _textStyleStr(PBDLTextStyle textStyle) {
    return '''
TextStyle(
  fontSize: ${textStyle.fontSize},
  fontWeight: FontWeight.w${textStyle.fontWeight},
  letterSpacing: ${textStyle.letterSpacing},
  fontFamily: \'${textStyle.fontFamily}\',
  decoration: ${PBTextGen.getDecoration(textStyle.textDecoration)},
  fontStyle: ${(textStyle.italics ?? false) ? 'FontStyle.italic' : 'FontStyle.normal'},
)
''';
  }
}
