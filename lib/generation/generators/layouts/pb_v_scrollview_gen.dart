import 'package:parabeac_core/generation/generators/layouts/pb_layout_gen.dart';
import 'package:parabeac_core/generation/generators/pb_widget_manager.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import '../pb_flutter_generator.dart';

class PBVerticalScrollViewGen extends PBLayoutGenerator {
  final PBGenerationManager manager;
  PBVerticalScrollViewGen(this.manager) : super('VERTICAL_SCROLLVIEW');
// PBIntermediateColumnLayout
  @override
  String generate(PBIntermediateNode source) {
    return '';
  }
}
