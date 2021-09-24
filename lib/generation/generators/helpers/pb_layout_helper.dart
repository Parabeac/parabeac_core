import 'package:parabeac_core/generation/generators/helpers/pb_gen_helper.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

class PBLayoutManager implements PBGenHelper {
  final List<PBLayoutIntermediateNode> _registeredGenLayouts = [];

  @override
  String generate(PBIntermediateNode source, PBContext generatorContext) {
    if (source == null) {
      throw NullThrownError();
    }
    if (source is PBLayoutIntermediateNode) {
      var buffer = StringBuffer();
      var body = _registeredGenLayouts
          .firstWhere((layout) => layout.runtimeType == source.runtimeType)
          .generator
          .generate(source, generatorContext);
      buffer.write(body);

      return buffer.toString();
    }
    return '';
  }

  @override
  bool containsIntermediateNode(PBIntermediateNode node) =>
      _registeredGenLayouts
          .any((layout) => layout.runtimeType == node.runtimeType);

  @override
  void registerIntemediateNode(PBIntermediateNode generator) {
    if (generator == null) {
      throw NullThrownError();
    }
    if (!containsIntermediateNode(generator)) {
      _registeredGenLayouts.add(generator);
    }
  }
}
