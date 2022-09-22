import 'package:get_it/get_it.dart';
import 'package:parabeac_core/analytics/amplitude_analytics_service.dart';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/comp_isolation/append_to_yaml_post_gen_task.dart';
import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/post_gen_task.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/add_constant_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/file_ownership_policy.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/path_services/path_service.dart';
import 'package:parabeac_core/generation/generators/value_objects/generation_configuration/pb_generation_configuration.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_image_reference_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/auxilary_data_helpers/intermediate_fill.dart';
import 'package:pbdl/pbdl.dart';
import 'package:recase/recase.dart';
import 'package:uuid/uuid.dart';

class ColorsPostGenTask extends PostGenTask {
  GenerationConfiguration generationConfiguration;

  List<PBDLGlobalStyle> fills;

  ColorsPostGenTask(
    this.generationConfiguration,
    this.fills,
  );
  @override
  void execute() {
    var constColors = <ConstantHolder>[];
    var constGradients = <ConstantHolder>[];
    var constImages = <ConstantHolder>[];
    // var mainInfo = MainInfo();

    /// Format colors to be added to constants file
    fills.forEach((fill) {
      // To add Constant Colors
      if (fill is PBDLGlobalColor) {
        constColors.add(ConstantHolder(
          'Color',
          fill.name.camelCase,
          'Color(${fill.color.toHex()})',
          description: fill.description,
        ));
      }
      // To add Constant Images
      else if (fill is PBDLGlobalImage) {
        var imageFill = PBFill.fromJson(fill.image.toJson());
        constImages.add(ConstantHolder(
          'Image',
          fill.name.camelCase,
          imageFill.initializerGenerator(),
          description: fill.description,
          isconst: false,
        ));
        // Append image path to yaml so it can get expose to be used
        if (imageFill.imageRef != null && imageFill.imageRef.isNotEmpty) {
          AppendToYamlPostGenTask.addAsset(
              imageFill.imageRef.replaceAll('images/', ''));
        }
      }
      // To add Constant Gradients
      else if (fill is PBDLGlobalGradient) {
        var gradientFill = PBFill.fromJson(fill.gradient.toJson());
        constGradients.add(ConstantHolder(
          _interpretType(gradientFill.type),
          fill.name.camelCase,
          gradientFill.initializerGenerator(),
          description: fill.description,
        ));
      }
    });

    /// Write list to constants file in `[$type].g.dart`
    createCommand(constColors, 'colors');
    createCommand(constGradients, 'gradients');
    createCommand(constImages, 'images');
  }

  String _interpretType(String type) {
    switch (type) {
      case 'GRADIENT_LINEAR':
        return 'LinearGradient';
      case 'GRADIENT_RADIAL':
        return 'RadialGradient';
      case 'GRADIENT_ANGULAR':
        return 'SweepGradient';
      default:
        return 'Gradient';
    }
  }

  void createCommand(List<ConstantHolder> list, String type) {
    var mainInfo = MainInfo();
    generationConfiguration.fileStructureStrategy.commandCreated(
      WriteConstantsCommand(
        Uuid().v4(),
        list,
        filename: '${mainInfo.projectName.snakeCase}_$type',
        ownershipPolicy: FileOwnership.PBC,
        imports: 'import \'package:flutter/material.dart\';',
        relativePath: GetIt.I.get<PathService>().themingRelativePath,
      ),
    );
  }
}
