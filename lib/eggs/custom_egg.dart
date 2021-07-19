import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/plugins/pb_plugin_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_attribute.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

class CustomEgg extends PBEgg implements PBInjectedIntermediate{
  @override
  String semanticName = '<custom>';
  CustomEgg(Point topLeftCorner, Point bottomRightCorner, PBContext currentContext, String name) : super(topLeftCorner, bottomRightCorner, currentContext, name) {
    addAttribute(PBAttribute('child'));
    generator = CustomEggGenerator();

  }

  @override
  void addChild(PBIntermediateNode node) {
    // TODO: implement addChild
  }

  @override
  void alignChild() {
    // TODO: implement alignChild
  }

  @override
  void extractInformation(DesignNode incomingNode) {
    // TODO: implement extractInformation
  }

  @override
  PBEgg generatePluginNode(Point topLeftCorner, Point bottomRightCorner, DesignNode originalRef) {
    // TODO: implement generatePluginNode
    throw UnimplementedError();
  }
  
}

class CustomEggGenerator extends PBGenerator{
  @override
  String generate(PBIntermediateNode source, PBContext context) {
    // TODO: implement generate
    throw UnimplementedError();
  }

} 