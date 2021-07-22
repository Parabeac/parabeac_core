// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pb_intermediate_node_tree.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBIntermediateTree _$PBIntermediateTreeFromJson(Map<String, dynamic> json) {
  return PBIntermediateTree(
    json['name'] as String,
  )
    ..lockData = json['lockData'] as bool
    ..rootNode = json['rootNode'] == null
        ? null
        : PBIntermediateNode.fromJson(json['rootNode'] as Map<String, dynamic>);
}

Map<String, dynamic> _$PBIntermediateTreeToJson(PBIntermediateTree instance) =>
    <String, dynamic>{
      'lockData': instance.lockData,
      'rootNode': instance.rootNode,
      'name': instance.name,
    };
