// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gradient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Gradient _$GradientFromJson(Map<String, dynamic> json) {
  return Gradient(
    classField: json['_class'] as String,
    elipseLength: (json['elipseLength'] as num)?.toDouble(),
    from: json['from'] as String,
    gradientType: (json['gradientType'] as num)?.toDouble(),
    stops: (json['stops'] as List)
        ?.map((e) =>
            e == null ? null : GradientStop.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    to: json['to'] as String,
  );
}

Map<String, dynamic> _$GradientToJson(Gradient instance) => <String, dynamic>{
      '_class': instance.classField,
      'elipseLength': instance.elipseLength,
      'from': instance.from,
      'gradientType': instance.gradientType,
      'to': instance.to,
      'stops': instance.stops,
    };
