import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/generation/generators/pb_widget_manager.dart';

class PrototypeGenerator extends PBGenerator {
  @override
  PBGenerationManager manager;

  PrototypeNode prototypeNode;

  PrototypeGenerator(String widgetType) : super(widgetType);

  @override
  String generate(PBIntermediateNode source) {
    // TODO:
    return '';
  }
}
