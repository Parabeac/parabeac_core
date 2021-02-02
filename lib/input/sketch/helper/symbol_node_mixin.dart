import 'dart:core';
import 'package:parabeac_core/input/sketch/entities/layers/abstract_group_layer.dart';
import 'package:parabeac_core/input/sketch/entities/layers/abstract_layer.dart';
import 'package:parabeac_core/input/sketch/entities/style/style.dart';
import 'package:parabeac_core/input/sketch/entities/style/text_style.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_bitmap.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:recase/recase.dart';

// both need to be global because a symbol instance could have multiple master symbols with name conflicts
Map<String, String> SN_UUIDtoVarName = {};
Map<String, int> varNameCount = {};

mixin SymbolNodeMixin {
  final Map<Type, String> typeToAbbreviation = {
    TextStyle: 'ts',
    String: 'str',
    Style: 'sty',
    InheritedBitmap: 'bm',
    PBSharedParameterValue: 'sv',
  };

  // should have been a Map<UUID, SketchNode> but iterate slowly through the list
  String FindName(String uuid, List children, Type type) {
    for (var child in children) {
      if (child.UUID == uuid) {
        var name =
            ((typeToAbbreviation[type] ?? 'un') + ' ' + (child.name ?? 'var'))
                .camelCase;
        return name.replaceAll(
            RegExp(
              r'[^A-Za-z0-9_]',
            ),
            '');
      } else if (child is AbstractGroupLayer) {
        var found = FindName(uuid, child.children, type);
        if (found != null) {
          return found;
        }
      }
    }
    // return null to indicate not found
    return null;
  }

  Map AddMasterSymbolName(String overrideName, List children) {
    var varName;
    var parmInfo = extractParameter(overrideName);
    var uuid = parmInfo['uuid'];

    var nodeName = FindName(uuid, children, parmInfo['type']) ?? 'var';
    // only increase count, make new varName if unique UUID
    if (!SN_UUIDtoVarName.containsKey(overrideName)) {
      var count = varNameCount[nodeName] ?? 0;
      varName = nodeName;
      varNameCount[nodeName] = count + 1;
      // first one doesn't have appended number
      if (count > 0) {
        varName += count.toString();
      }
      SN_UUIDtoVarName[overrideName] = varName;
    } else {
      varName = SN_UUIDtoVarName[overrideName];
    }

    return {'name': varName, 'type': parmInfo['type'], 'uuid': uuid};
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
      case 'textStyle':
        type = TextStyle;
        break;
      case 'style':
        type = Style;
        break;
      default:
        type = String;
    }

    return {'type': type, 'uuid': uuid};
  }
}
