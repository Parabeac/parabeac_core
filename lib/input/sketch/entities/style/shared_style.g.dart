// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_style.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SharedStyle _$SharedStyleFromJson(Map<String, dynamic> json) {
  return SharedStyle(
    classField: json['_class'] as String,
    UUID: json['do_objectID'] as String,
    name: json['name'] as String,
    style: json['value'] == null
        ? null
        : Style.fromJson(json['value'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SharedStyleToJson(SharedStyle instance) =>
    <String, dynamic>{
      '_class': instance.classField,
      'do_objectID': instance.UUID,
      'name': instance.name,
      'value': instance.style,
    };
