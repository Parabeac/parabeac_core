// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'design_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DesignNode _$DesignNodeFromJson(Map<String, dynamic> json) {
  return DesignNode(
    json['UUID'] as String,
    json['name'] as String,
    json['isVisible'] as bool,
    json['boundaryRectangle'],
    json['type'] as String,
  );
}

Map<String, dynamic> _$DesignNodeToJson(DesignNode instance) =>
    <String, dynamic>{
      'UUID': instance.UUID,
      'name': instance.name,
      'isVisible': instance.isVisible,
      'boundaryRectangle': instance.boundaryRectangle,
      'type': instance.type,
    };
