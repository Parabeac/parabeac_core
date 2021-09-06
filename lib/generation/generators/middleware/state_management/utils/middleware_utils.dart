import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_state_management_helper.dart';
import 'package:recase/recase.dart';

class MiddlewareUtils {
  static String generateChangeNotifierClass(String defaultStateName,
      PBGenerationManager manager, PBIntermediateNode node, PBContext context) {
    var overrideVars = ''; // Variables outside of initializer
    var overrideAttr = ''; // Attributes that will be part of initializer
    var stateInitializers = StringBuffer();
    var stateBuffer = StringBuffer();

    if (node is PBSharedMasterNode &&
        (node.overridableProperties?.isNotEmpty ?? false)) {
      node.overridableProperties.forEach((prop) {
        overrideVars += 'final ${prop.propertyName};';
        overrideAttr += 'this.${prop.propertyName}, ';
      });
      stateBuffer.write(MiddlewareUtils.generateEmptyVariable(node));
      stateInitializers.write(
          '${node.name.camelCase} = ${MiddlewareUtils.generateVariableBody(node, context)}');
    } else {
      stateBuffer.write(MiddlewareUtils.generateVariable(node, context));
    }

    var stmgHelper = PBStateManagementHelper();

    stmgHelper.getStateGraphOfNode(node).states?.forEach((state) {
      context.tree.generationViewData = context.managerData;

      if (state is PBSharedMasterNode &&
          (state.overridableProperties?.isNotEmpty ?? false)) {
        state.overridableProperties.forEach((prop) {
          var friendlyName = prop.propertyName;
          overrideVars += 'final $friendlyName;';
          overrideAttr += 'this.$friendlyName, ';
        });
        stateBuffer.write(MiddlewareUtils.generateEmptyVariable(state));
        stateInitializers.write(
            '${state.name.camelCase} = ${MiddlewareUtils.generateVariableBody(state, context)}');
      } else {
        stateBuffer.writeln(MiddlewareUtils.generateVariable(state, context));
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

  static String generateModelChangeNotifier(String defaultStateName,
      PBGenerationManager manager, PBIntermediateNode node, PBContext context) {
    // Pass down manager data to states
    PBStateManagementHelper()
        .getStateGraphOfNode(node)
        .states
        ?.forEach((state) {
      // context.tree = node.managerData;
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

  static String generateVariable(PBIntermediateNode node, PBContext context,
      {String type = 'var'}) {
    return '$type ${node.name.camelCase} = ${generateVariableBody(node, context)};';
  }

  static String generateEmptyVariable(PBIntermediateNode node,
          {String type = 'var'}) =>
      '$type ${node.name.camelCase};';

  static String generateVariableBody(
      PBIntermediateNode node, PBContext context) {
    context.sizingContext = SizingValueContext.PointValue;
    return (node?.generator?.generate(node ?? '', context) ?? '');
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
