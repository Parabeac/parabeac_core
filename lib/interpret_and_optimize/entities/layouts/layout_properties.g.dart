// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'layout_properties.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LayoutProperties _$LayoutPropertiesFromJson(Map<String, dynamic> json) {
  return LayoutProperties(
    spacing: json['spacing'] as num,
    leftPadding: json['leftPadding'] as num,
    rightPadding: json['rightPadding'] as num,
    topPadding: json['topPadding'] as num,
    bottomPadding: json['bottomPadding'] as num,
    crossAxisAlignment: _$enumDecodeNullable(
        _$IntermediateAxisAlignmentEnumMap, json['counterAxisAlignment']),
    primaryAxisAlignment: _$enumDecodeNullable(
        _$IntermediateAxisAlignmentEnumMap, json['primaryAxisAlignment']),
    crossAxisSizing: _$enumDecodeNullable(
        _$IntermediateAxisModeEnumMap, json['counterAxisSizing']),
    primaryAxisSizing: _$enumDecodeNullable(
        _$IntermediateAxisModeEnumMap, json['primaryAxisSizing']),
  );
}

Map<String, dynamic> _$LayoutPropertiesToJson(LayoutProperties instance) =>
    <String, dynamic>{
      'spacing': instance.spacing,
      'leftPadding': instance.leftPadding,
      'rightPadding': instance.rightPadding,
      'topPadding': instance.topPadding,
      'bottomPadding': instance.bottomPadding,
      'primaryAxisAlignment':
          _$IntermediateAxisAlignmentEnumMap[instance.primaryAxisAlignment],
      'counterAxisAlignment':
          _$IntermediateAxisAlignmentEnumMap[instance.crossAxisAlignment],
      'primaryAxisSizing':
          _$IntermediateAxisModeEnumMap[instance.primaryAxisSizing],
      'counterAxisSizing':
          _$IntermediateAxisModeEnumMap[instance.crossAxisSizing],
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

const _$IntermediateAxisAlignmentEnumMap = {
  IntermediateAxisAlignment.START: 'START',
  IntermediateAxisAlignment.CENTER: 'CENTER',
  IntermediateAxisAlignment.END: 'END',
};

const _$IntermediateAxisModeEnumMap = {
  IntermediateAxisMode.FIXED: 'FIXED',
  IntermediateAxisMode.HUGGED: 'HUGGED',
};
