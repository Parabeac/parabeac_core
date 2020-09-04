// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'override_property.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OverridableProperty _$OverridablePropertyFromJson(Map<String, dynamic> json) {
  return OverridableProperty(
    json['overrideName'] as String,
    json['canOverride'] as bool,
  );
}

Map<String, dynamic> _$OverridablePropertyToJson(
        OverridableProperty instance) =>
    <String, dynamic>{
      'overrideName': instance.overrideName,
      'canOverride': instance.canOverride,
    };
