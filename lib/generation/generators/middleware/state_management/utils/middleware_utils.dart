import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/input/sketch/helper/symbol_node_mixin.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:recase/recase.dart';

class MiddlewareUtils {
  static String generateChangeNotifierClass(
    String defaultStateName,
    PBGenerationManager manager,
    PBIntermediateNode node,
  ) {
    var overrideVars = ''; // Variables outside of initializer
    var overrideAttr = ''; // Attributes that will be part of initializer
    var stateInitializers = StringBuffer();
    var stateBuffer = StringBuffer();

    if (node is PBSharedMasterNode &&
        (node.overridableProperties?.isNotEmpty ?? false)) {
      node.overridableProperties.forEach((prop) {
        overrideVars += 'final ${prop.friendlyName};';
        overrideAttr += 'this.${prop.friendlyName}, ';
      });
      stateBuffer.write(MiddlewareUtils.generateEmptyVariable(node));
      stateInitializers.write(
          '${node.name.camelCase} = ${MiddlewareUtils.generateVariableBody(node)}');
    } else {
      stateBuffer.write(MiddlewareUtils.generateVariable(node));
    }
    node?.auxiliaryData?.stateGraph?.states?.forEach((state) {
      state.variation.node.currentContext.tree.data = node.managerData;
      var variationNode = state.variation.node;

      if (variationNode is PBSharedMasterNode &&
          (variationNode.overridableProperties?.isNotEmpty ?? false)) {
        variationNode.overridableProperties.forEach((prop) {
          var friendlyName = SN_UUIDtoVarName[prop.propertyName] ?? 'NOTFOUND';
          overrideVars += 'final $friendlyName;';
          overrideAttr += 'this.$friendlyName, ';
        });
        stateBuffer.write(MiddlewareUtils.generateEmptyVariable(variationNode));
        stateInitializers.write(
            '${variationNode.name.camelCase} = ${MiddlewareUtils.generateVariableBody(variationNode)}');
      } else {
        stateBuffer.writeln(MiddlewareUtils.generateVariable(variationNode));
      }
    });

    return '''
      ${manager.generateImports()}
      class $defaultStateName extends ChangeNotifier {
      ${stateBuffer.toString()}
      $overrideVars

      Widget defaultWidget;
      $defaultStateName(${overrideAttr.isNotEmpty ? ('\{' + overrideAttr + '\}') : ''}){

        $stateInitializers

        defaultWidget = ${node.name.camelCase};
      }
      }
      ''';
  }

  static String generateModelChangeNotifier(
    String defaultStateName,
    PBGenerationManager manager,
    PBIntermediateNode node,
  ) {
    // Pass down manager data to states
    node?.auxiliaryData?.stateGraph?.states?.forEach((state) {
      state.variation.node.currentContext.tree.data = node.managerData;
    });
    return '''
      ${manager.generateImports()}
      class $defaultStateName extends ChangeNotifier {

      Widget currentWidget;
      $defaultStateName(){}

      // default provider event handler for gestures.
      void onGesture() {
      }
      
      void setCurrentWidget(Widget currentWidget) {
        this.currentWidget = currentWidget;
      }
      }
      ''';
  }

  static String generateVariable(PBIntermediateNode node,
      {String type = 'var'}) {
    return '$type ${node.name.camelCase} = ${generateVariableBody(node)};';
  }

  static String generateEmptyVariable(PBIntermediateNode node,
          {String type = 'var'}) =>
      '$type ${node.name.camelCase};';

  static String generateVariableBody(PBIntermediateNode node) {
    node.currentContext.sizingContext = SizingValueContext.PointValue;
    (node?.generator?.generate(node ?? '', node.currentContext) ?? '') + ';';
  }

  static String wrapOnLayout(String className) {
    return '''
    LayoutBuilder(builder: (context, constraints) {
        return $className(
          constraints,
        );
      })
    ''';
  }
}
