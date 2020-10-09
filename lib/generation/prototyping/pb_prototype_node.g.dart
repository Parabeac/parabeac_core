// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pb_prototype_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrototypeNode _$PrototypeNodeFromJson(Map<String, dynamic> json) {
  return PrototypeNode(
    json['destinationUUID'] as String,
    destinationName: json['destinationName'] as String,
  );
}

Map<String, dynamic> _$PrototypeNodeToJson(PrototypeNode instance) =>
    <String, dynamic>{
      'destinationUUID': instance.destinationUUID,
      'destinationName': instance.destinationName,
    };
