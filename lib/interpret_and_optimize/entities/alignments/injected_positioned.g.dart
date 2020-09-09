// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'injected_positioned.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InjectedPositioned _$InjectedPositionedFromJson(Map<String, dynamic> json) {
  return InjectedPositioned(
    json['UUID'] as String,
  )
    ..subsemantic = json['subsemantic'] as String
    ..topLeftCorner = json['topLeftCorner'] == null
        ? null
        : Point.fromJson(json['topLeftCorner'] as Map<String, dynamic>)
    ..bottomRightCorner = json['bottomRightCorner'] == null
        ? null
        : Point.fromJson(json['bottomRightCorner'] as Map<String, dynamic>)
    ..color = json['color'] as String
    ..size = json['size'] as Map<String, dynamic>
    ..borderInfo = json['borderInfo'] as Map<String, dynamic>
    ..alignment = json['alignment'] as Map<String, dynamic>
    ..name = json['name'] as String
    ..child = json['child']
    ..widgetType = json['widgetType'] as String
    ..horizontalAlignValue = (json['horizontalAlignValue'] as num)?.toDouble()
    ..verticalAlignValue = (json['verticalAlignValue'] as num)?.toDouble()
    ..horizontalAlignType = json['horizontalAlignType'] as String
    ..verticalAlignType = json['verticalAlignType'] as String;
}

Map<String, dynamic> _$InjectedPositionedToJson(InjectedPositioned instance) =>
    <String, dynamic>{
      'subsemantic': instance.subsemantic,
      'topLeftCorner': instance.topLeftCorner,
      'bottomRightCorner': instance.bottomRightCorner,
      'color': instance.color,
      'size': instance.size,
      'borderInfo': instance.borderInfo,
      'alignment': instance.alignment,
      'name': instance.name,
      'child': instance.child,
      'UUID': instance.UUID,
      'widgetType': instance.widgetType,
      'horizontalAlignValue': instance.horizontalAlignValue,
      'verticalAlignValue': instance.verticalAlignValue,
      'horizontalAlignType': instance.horizontalAlignType,
      'verticalAlignType': instance.verticalAlignType,
    };
