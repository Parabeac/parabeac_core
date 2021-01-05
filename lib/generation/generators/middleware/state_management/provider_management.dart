import 'package:parabeac_core/generation/generators/attribute-helper/pb_generator_context.dart';
import 'package:parabeac_core/generation/generators/middleware/middleware.dart';
import 'package:parabeac_core/generation/generators/pb_generation_manager.dart';
import 'package:parabeac_core/generation/generators/pb_variable.dart';
import 'package:parabeac_core/generation/generators/value_objects/generator_adapter.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

class ProviderMiddleware extends Middleware {
  final PACKAGE_NAME = 'provider';
  final PACKAGE_VERSION = '1.0.0';

  ProviderMiddleware(PBGenerationManager generationManager)
      : super(generationManager);

  @override
  Future<PBIntermediateNode> applyMiddleware(PBIntermediateNode node) {
    if (node?.auxiliaryData?.stateGraph?.states?.isNotEmpty ?? false) {
      var watcherName = getNameOfNode(node);
      var manager = generationManager;
      var fileStrategy = manager.fileStrategy;

      var watcher = PBVariable(watcherName, 'final ', true, 'watch(context)');
      manager.addDependencies(PACKAGE_NAME, PACKAGE_VERSION);
      manager.addImport('import provider');
      manager.addMethodVariable(watcher);
      //TODO iterate states,
      // for (var state in node.auxiliaryData.stateGraph.states) {
      // }
      fileStrategy.generatePage(
          node.generator.generate(node, GeneratorContext()),
          '${fileStrategy.GENERATED_PROJECT_PATH}${fileStrategy.RELATIVE_VIEW_PATH}.g.dart');
      node.generator = StringGeneratorAdapter(watcherName);
    }
    return Future.value(node);
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
}
