import 'package:parabeac_core/interpret_and_optimize/entities/inherited_bitmap.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';

mixin SymbolNodeMixin {
  ///Extracting the UUID of the parameter either from the [SymbolInstance]
  ///or the [SymbolMaster].
  ///The first element in the [List] is going to be the UUID, while
  ///the second element is going to be the [Type].
  List extractParameter(String overrideName) {
    var properties = overrideName.split('_');
    assert(properties.length > 1,
        'The symbol ($overrideName) parameter does not contain sufficient data');
    var type, uuid = properties[0];

    switch (properties[1]) {
      case 'stringValue':
        type = String;
        break;
      case 'symbolID':
        type = PBSharedParameterValue;
        break;
      case 'image':
        type = InheritedBitmap;
        break;
      default:
        type = String;
    }
    return [type, uuid];
  }
}
