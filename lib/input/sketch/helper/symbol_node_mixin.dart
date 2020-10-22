import 'dart:core';

import 'package:parabeac_core/input/sketch/entities/layers/abstract_layer.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_bitmap.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';

Map<String, String> SN_UUIDtoVarName = {};

mixin SymbolNodeMixin {
  static Map<String, SymbolNodeMixin> masterSymbols;
  Map<String, int> varNameCount = {};

  String GetMasterSymbolName(String uuid) {
    return SN_UUIDtoVarName[uuid];
  }

  // should have been a Map<UUID, SketchNode> but iterate slowly through the list
  String FindName(String uuid, List<SketchNode> children) {
    for (var child in children) {
      if (child.UUID == uuid) {
        return child.name ?? 'var';
      }
    }
    // this should never happen.
    return 'var';
  }

  Map AddMasterSymbolName(String overrideName, List children){

    var varName;
    var parmInfo = extractParameter(overrideName);
    var uuid = parmInfo['uuid'];

    var nodeName = FindName(uuid, children);
    // only increase count, make new varName if unique UUID
    if (!SN_UUIDtoVarName.containsKey(uuid)) {
      var count = varNameCount[nodeName] ?? 0;
      varName = 'ovr_' + nodeName;
      varNameCount[nodeName] = count + 1;
      // first one doesn't have appended number
      if (count > 0) {
        varName += count.toString();
      }
      SN_UUIDtoVarName[uuid] = varName;
    } else {
      varName = SN_UUIDtoVarName[uuid];
    }

    return {'name': varName, 'type': parmInfo['type'], 'uuid': uuid };

  }

  ///Extracting the UUID of the parameter either from the [SymbolInstance]
  ///or the [SymbolMaster].
  ///The first element in the [List] is going to be the UUID, while
  ///the second element is going to be the [Type].
  Map extractParameter(String overrideName) {
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

    return { 'type': type, 'uuid': uuid};
  }
}
