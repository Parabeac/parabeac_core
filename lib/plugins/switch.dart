import 'package:parabeac_core/generation/generators/pb_flutter_generator.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/pb_param.dart';
import 'package:parabeac_core/generation/generators/plugins/pb_plugin_node.dart';
import 'package:parabeac_core/input/entities/layers/abstract_layer.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

import '../input/entities/layers/abstract_layer.dart';
import '../interpret_and_optimize/helpers/pb_context.dart';

class Switch extends PBNakedPluginNode implements PBInjectedIntermediate {
  Switch(Point topLeftCorner, Point bottomRightCorner, this.UUID,
      {this.currentContext})
      : super(topLeftCorner, bottomRightCorner, currentContext) {
    generator = SwitchGenerator(widgetType);
  }

  PBContext currentContext;

  final String UUID;

  String widgetType = 'Switch';

  String semanticName = '.*switch';

  @override
  void addChild(PBIntermediateNode node) {}

  @override
  void alignChild() {}

  @override
  void extractInformation(SketchNode incomingNode) {}

  @override
  PBNakedPluginNode generatePluginNode(
      Point topLeftCorner, Point bottomRightCorner, SketchNode originalRef) {
    return Switch(topLeftCorner, bottomRightCorner, UUID,
        currentContext: currentContext);
    // throw UnimplementedError();
  }
}

class SwitchGenerator extends PBGenerator {
  SwitchGenerator(String widgetType) : super(widgetType);

  @override
  String generate(PBIntermediateNode source) {
    if (source is Switch) {
      var value = PBParam('switchValue', 'bool', false);
      manager.addInstanceVariable(value);
      manager.addDependencies('list_tile_switch', '^0.0.2');
      manager.addImport('package:list_tile_switch/list_tile_switch.dart');
      var buffer = StringBuffer();
      buffer.write('''ListTileSwitch(  
        value: switchValue,  
      leading: Icon(Icons.access_alarms),  
      onChanged: (value) {  
        setState(() {  
        switchValue = value;  
        });
      },
      visualDensity: VisualDensity.comfortable,
      switchType: SwitchType.cupertino,
      switchActiveColor: Colors.indigo,  
      title: Text('Default Custom Switch'),  
    ),
   ''');
      return buffer.toString();
    }
    throw UnimplementedError();
  }
}
