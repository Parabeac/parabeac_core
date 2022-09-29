import 'package:get_it/get_it.dart';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/post_gen_task.dart';
import 'package:parabeac_core/generation/generators/attribute-helper/pb_color_gen_helper.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/add_constant_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/file_ownership_policy.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/path_services/path_service.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/pb_generation_configuration.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_color.dart';
import 'package:pbdl/pbdl.dart';
import 'package:recase/recase.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

class EffectsPostGenTask extends PostGenTask {
  GenerationConfiguration generationConfiguration;
  List<PBDLGlobalEffect> effects;

  EffectsPostGenTask(
    this.generationConfiguration,
    this.effects,
  );

  @override
  void execute() {
    var constLayerBlurs = <ConstantHolder>[];
    var constBackgroundBlurs = <ConstantHolder>[];
    var constDropShadows = <ConstantHolder>[];
    var constInnerShadows = <ConstantHolder>[];

    /// Go through each effect
    effects.forEach((effect) {
      switch (effect.effect.type) {
        case 'LAYER_BLUR':
          constLayerBlurs.add(ConstantHolder(
            'ImageFiltered',
            effect.name.camelCase + '(Widget child)',
            _getLayerBlur(effect.effect),
            description: effect.description,
            isconst: false,
            isFunction: true,
          ));
          break;
        case 'BACKGROUND_BLUR':
          constBackgroundBlurs.add(ConstantHolder(
            'ClipRect',
            effect.name.camelCase + '(Widget child)',
            _getBackgroundBlur(effect.effect),
            description: effect.description,
            isconst: false,
            isFunction: true,
          ));
          break;
        case 'DROP_SHADOW':
          constDropShadows.add(ConstantHolder(
            'BoxShadow',
            effect.name.camelCase.toLowerCase(),
            _getDropShadow(effect.effect),
            description: effect.description,
          ));
          break;

        case 'INNER_SHADOW':

          /// TODO: Empty for now
          break;
        default:
      }
    });

    /// Write list to constants file in `[$type].g.dart`
    createCommand(constLayerBlurs, 'layer_blur',
        imports: ['import \'dart:ui\';']);
    createCommand(constBackgroundBlurs, 'background_blur',
        imports: ['import \'dart:ui\';']);
    createCommand(constDropShadows, 'drop_shadow');
  }

  void createCommand(List<ConstantHolder> list, String type,
      {List<String> imports}) {
    var mainInfo = MainInfo();
    generationConfiguration.fileStructureStrategy.commandCreated(
      WriteConstantsCommand(
        Uuid().v4(),
        list,
        filename: '${mainInfo.projectName.snakeCase}_$type',
        ownershipPolicy: FileOwnership.PBC,
        imports: 'import \'package:flutter/material.dart\';\n' +
            ((imports != null) ? imports.join() : '\n'),
        relativePath: path.join(
            GetIt.I.get<PathService>().themingRelativePath, 'effects'),
      ),
    );
  }

  String _getLayerBlur(var effect) {
    return '''
ImageFiltered(
  imageFilter: ImageFilter.blur(
    sigmaX: ${effect.radius},
    sigmaY: ${effect.radius},
  ),
  child: child,
)
''';
  }

  String _getBackgroundBlur(var effect) {
    return '''
ClipRect(
  child: BackdropFilter(
    filter: ImageFilter.blur(
      sigmaX: ${effect.radius},
      sigmaY: ${effect.radius},
    ),
    child: child,
  )
)
''';
  }

  String _getDropShadow(var effect) {
    var color = PBColor.fromJson(effect.color.toJson());
    return '''
BoxShadow(
  offset: Offset(${effect.offset['x']}, ${effect.offset['y']}),
  ${PBColorGenHelper().getHexColor(color)}
  spreadRadius: 0.0,
  blurRadius: ${effect.radius},
)
''';
  }
}
