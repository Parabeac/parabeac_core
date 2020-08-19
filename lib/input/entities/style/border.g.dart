// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'border.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Border _$BorderFromJson(Map<String, dynamic> json) {
  return Border(
    classField: json['_class'] as String,
    color: json['color'] == null
        ? null
        : Color.fromJson(json['color'] as Map<String, dynamic>),
    contextSettings: json['contextSettings'] == null
        ? null
        : ContextSettings.fromJson(
            json['contextSettings'] as Map<String, dynamic>),
    fillType: (json['fillType'] as num)?.toDouble(),
    gradient: json['gradient'] == null
        ? null
        : Gradient.fromJson(json['gradient'] as Map<String, dynamic>),
    isEnabled: json['isEnabled'] as bool,
    position: (json['position'] as num)?.toDouble(),
    thickness: (json['thickness'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$BorderToJson(Border instance) => <String, dynamic>{
      '_class': instance.classField,
      'isEnabled': instance.isEnabled,
      'fillType': instance.fillType,
      'color': instance.color,
      'contextSettings': instance.contextSettings,
      'gradient': instance.gradient,
      'position': instance.position,
      'thickness': instance.thickness,
    };
