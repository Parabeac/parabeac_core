// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intermediate_effect.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBEffect _$PBEffectFromJson(Map<String, dynamic> json) {
  return PBEffect(
    type: _$enumDecodeNullable(_$EffectTypeEnumMap, json['type']),
    visible: json['visible'] as bool,
    radius: json['radius'] as num,
    color: json['color'] == null
        ? null
        : PBDLColor.fromJson(json['color'] as Map<String, dynamic>),
    blendMode: json['blendMode'] as String,
    offset: json['offset'] as Map<String, dynamic>,
    showShadowBehindNode: json['showShadowBehindNode'] as bool,
  )..pbdlType = json['pbdlType'] as String;
}

Map<String, dynamic> _$PBEffectToJson(PBEffect instance) => <String, dynamic>{
      'type': _$EffectTypeEnumMap[instance.type],
      'visible': instance.visible,
      'radius': instance.radius,
      'color': instance.color?.toJson(),
      'blendMode': instance.blendMode,
      'offset': instance.offset,
      'showShadowBehindNode': instance.showShadowBehindNode,
      'pbdlType': instance.pbdlType,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$EffectTypeEnumMap = {
  EffectType.LAYER_BLUR: 'LAYER_BLUR',
  EffectType.DROP_SHADOW: 'DROP_SHADOW',
  EffectType.INNER_SHADOW: 'INNER_SHADOW',
  EffectType.BACKGROUND_BLUR: 'BACKGROUND_BLUR',
};
