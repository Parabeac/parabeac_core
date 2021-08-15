// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pb_intermediate_node_tree.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBIntermediateTree _$PBIntermediateTreeFromJson(Map<String, dynamic> json) {
  return PBIntermediateTree(
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$PBIntermediateTreeToJson(PBIntermediateTree instance) =>
    <String, dynamic>{
      'designNode': instance.rootNode,
      'name': instance.name,
    };
