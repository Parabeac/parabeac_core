// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupNode _$GroupNodeFromJson(Map<String, dynamic> json) {
  return GroupNode(
    (json['children'] as List)
        .map((e) => DesignNode.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$GroupNodeToJson(GroupNode instance) => <String, dynamic>{
      'children': instance.children,
    };
