// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pb_symbol_instance_overridable_value.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBSymbolInstanceOverridableValue _$PBSymbolInstanceOverridableValueFromJson(
    Map<String, dynamic> json) {
  return PBSymbolInstanceOverridableValue(
    json['do_objectID'] as String,
    json['value'],
    PBSymbolInstanceOverridableValue._typeFromJson(json['type']),
  );
}

Map<String, dynamic> _$PBSymbolInstanceOverridableValueToJson(
        PBSymbolInstanceOverridableValue instance) =>
    <String, dynamic>{
      'type': PBSymbolInstanceOverridableValue._typeToJson(instance.type),
      'do_objectID': instance.UUID,
      'value': instance.value,
    };
