import 'package:parabeac_core/generation/generators/attribute-helper/pb_generator_context.dart';
import 'package:parabeac_core/generation/generators/middleware/middleware.dart';
import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/pb_variable.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy.dart/provider_file_structure_strategy.dart';
import 'package:recase/recase.dart';
import 'package:parabeac_core/generation/generators/value_objects/generator_adapter.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

class ProviderMiddleware extends Middleware {
  final PACKAGE_NAME = 'provider';
  final PACKAGE_VERSION = '1.0.0';

  ProviderMiddleware(PBGenerationManager generationManager)
      : super(generationManager);

  @override
  Future<PBIntermediateNode> applyMiddleware(PBIntermediateNode node) async {
    if (node?.auxiliaryData?.stateGraph?.states?.isNotEmpty ?? false) {
      var watcherName = getNameOfNode(node);
      var manager = generationManager;
      var fileStrategy = manager.fileStrategy as ProviderFileStructureStrategy;

      var watcher = PBVariable(watcherName, 'final ', true, 'watch(context)');
      manager.addDependencies(PACKAGE_NAME, PACKAGE_VERSION);
      manager.addMethodVariable(watcher);
      // Iterating through states
      var stateBuffer = StringBuffer();
      stateBuffer.write(_generateProviderVariable(node));
      node.auxiliaryData.stateGraph.states.forEach((state) async {
        var variationNode = state.variation.node;

        stateBuffer.write(_generateProviderVariable(variationNode));
      });

      var code =
          _generateProviderClass(stateBuffer.toString(), watcherName, manager);
      fileStrategy.writeProviderModelFile(code, node.name.snakeCase);
      node.generator = StringGeneratorAdapter(watcherName.snakeCase);
    }
    return Future.value(node);
  }

  String _generateProviderClass(
      String states, String defaultStateName, PBGenerationManager manager) {
    return '''
      ${manager.generateImports()}
      class ${defaultStateName} extends ChangeNotifierProvider {
      ${states}
      }
      ''';
  }

  String _generateProviderVariable(PBIntermediateNode node) {
    return 'var ${node.name.camelCase} = ' +
        node?.generator?.generate(node ?? '',
            GeneratorContext(sizingContext: SizingValueContext.PointValue)) +
        ';';
  }

  ///lib/models/Custombutton.dart - models
  ///class CustomButton extends ModelLister{
  ///
  ///Button colorBlue = FlatButton( color: Colors.Blue),
  /// Button colorRed = FlatButton( color: Colors.Red).
  ///Button defaultButton = colorBlue;
  ///TODO developer does this
  ///void onclick(){
  ///defaultButton = colorRed;
  /// notifyListeners();
  ///}
  ///}
  ///lib/screes/screen1/
  ///class screen1 extends stateful{
  ///...
  ///
  ///build(BuildContext context){
  ///final customButton = watch(context);
  ///return ...
  ///
  ///Container(
  /// child: customButton;//FlatButton(colors: Colors.Red)
  ///)
  ///
  ///GestureDetector(build: onClick())
  ///}
  ///

  /// TODO: Use this method as baseline for stateful generation.
  // @override
  // Future<PBIntermediateNode> applyMiddleware(PBIntermediateNode node) async {
  //   if (node?.auxiliaryData?.stateGraph?.states?.isNotEmpty ?? false) {
  //     var watcherName = getNameOfNode(node);
  //     var manager = generationManager;
  //     var fileStrategy = manager.fileStrategy;

  //     var watcher = PBVariable(watcherName, 'final ', true, 'watch(context)');
  //     manager.addDependencies(PACKAGE_NAME, PACKAGE_VERSION);
  //     manager.addImport('import provider');
  //     manager.addMethodVariable(watcher);
  //     // Iterating through states
  //     node.auxiliaryData.stateGraph.states.forEach((state) async {
  //       var variationNode = state.variation.node;
  //       var statelessNode = manager.generate(node);
  //       await fileStrategy.generatePage(statelessNode,
  //           '${fileStrategy.GENERATED_PROJECT_PATH}${fileStrategy.RELATIVE_VIEW_PATH}${variationNode.name.snakeCase}.g.dart',
  //           args: 'SCREEN');
  //       print(state.variation.node);
  //     });

  //     await fileStrategy.generatePage(
  //         node.generator.generate(node, GeneratorContext()),
  //         '${fileStrategy.GENERATED_PROJECT_PATH}${fileStrategy.RELATIVE_VIEW_PATH}.g.dart');
  //     node.generator = StringGeneratorAdapter(watcherName);
  //   }
  //   return Future.value(node);
  // }
}
