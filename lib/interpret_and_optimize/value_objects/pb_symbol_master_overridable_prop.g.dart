// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pb_symbol_master_overridable_prop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBSymbolMasterOverridableProperty _$PBSymbolMasterOverridablePropertyFromJson(
    Map<String, dynamic> json) {
  return PBSymbolMasterOverridableProperty(
    json['canOverride'] as bool,
    json['overrideName'] as String,
  );
}

Map<String, dynamic> _$PBSymbolMasterOverridablePropertyToJson(
        PBSymbolMasterOverridableProperty instance) =>
    <String, dynamic>{
      'canOverride': instance.canOverride,
      'overrideName': instance.overrideName,
    };
