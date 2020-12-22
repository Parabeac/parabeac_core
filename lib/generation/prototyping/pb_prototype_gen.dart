import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

class PBPrototypeGenerator extends PBGenerator {
  PrototypeNode prototypeNode;
  PBPrototypeStorage _storage;

  PBPrototypeGenerator(this.prototypeNode) : super() {
    _storage = PBPrototypeStorage();
  }

  @override
  String generate(PBIntermediateNode source) {
    var name = _storage.getPageNodeById(prototypeNode.destinationUUID)?.name;
    if (name != null && name.isNotEmpty) {
      return '''GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ${name}()),
        );
      },
      child: ${manager.generate(source.child)},
      )''';
    } else {
      return manager.generate(source.child);
    }
  }
}
