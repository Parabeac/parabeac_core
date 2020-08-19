// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blur.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Blur _$BlurFromJson(Map<String, dynamic> json) {
  return Blur(
    center: json['center'] as String,
    classField: json['_class'] as String,
    isEnabled: json['isEnabled'] as bool,
    motionAngle: (json['motionAngle'] as num)?.toDouble(),
    radius: (json['radius'] as num)?.toDouble(),
    saturation: (json['saturation'] as num)?.toDouble(),
    type: (json['type'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$BlurToJson(Blur instance) => <String, dynamic>{
      '_class': instance.classField,
      'isEnabled': instance.isEnabled,
      'center': instance.center,
      'motionAngle': instance.motionAngle,
      'radius': instance.radius,
      'saturation': instance.saturation,
      'type': instance.type,
    };
