// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'figma_constraints.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FigmaConstraints _$FigmaConstraintsFromJson(Map<String, dynamic> json) {
  return FigmaConstraints(
    _$enumDecodeNullable(_$FigmaConstraintTypeEnumMap, json['horizontal']),
    _$enumDecodeNullable(_$FigmaConstraintTypeEnumMap, json['vertical']),
  );
}

Map<String, dynamic> _$FigmaConstraintsToJson(FigmaConstraints instance) =>
    <String, dynamic>{
      'horizontal': _$FigmaConstraintTypeEnumMap[instance.horizontal],
      'vertical': _$FigmaConstraintTypeEnumMap[instance.vertical],
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

const _$FigmaConstraintTypeEnumMap = {
  FigmaConstraintType.CENTER: 'CENTER',
  FigmaConstraintType.TOP_BOTTOM: 'TOP_BOTTOM',
  FigmaConstraintType.LEFT_RIGHT: 'LEFT_RIGHT',
  FigmaConstraintType.SCALE: 'SCALE',
  FigmaConstraintType.TOP: 'TOP',
  FigmaConstraintType.BOTTOM: 'BOTTOM',
  FigmaConstraintType.RIGHT: 'RIGHT',
  FigmaConstraintType.LEFT: 'LEFT',
};
