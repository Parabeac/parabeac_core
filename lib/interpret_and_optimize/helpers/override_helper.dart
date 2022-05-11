import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';

class OverrideHelper {
  /// Map to keep track of overrides.
  ///
  /// The `key` is the [UUID] of the override property,
  /// while the `value` is the [List] of the properties for that particular element.
  /// This is useful in the case that a single UUID contains many overrides like text content and text style.
  static final SN_UUIDtoVarName = <String, List<PBMasterOverride>>{};

  /// Adds `property` to `SN_UUIDtoVarName` map based on `property`'s [UUID]
  static void addProperty(PBMasterOverride property) {
    if (SN_UUIDtoVarName.containsKey(property.UUID)) {
      SN_UUIDtoVarName[property.UUID].add(property);
    } else {
      SN_UUIDtoVarName[property.UUID] = [property];
    }
  }

  /// Returns a `PBMasterOverride` matching given `uuid` and `type` of override.
  ///
  /// Returns [null] if no match is found
  static PBMasterOverride getProperty(String uuid, String type) {
    if (SN_UUIDtoVarName.containsKey(uuid)) {
      return SN_UUIDtoVarName[uuid]
          .firstWhere((element) => element.ovrType == type, orElse: () => null);
    }
    return null;
  }
}
