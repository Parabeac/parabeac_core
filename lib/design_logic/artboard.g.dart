// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artboard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Artboard _$ArtboardFromJson(Map<String, dynamic> json) {
  return Artboard(
    json['backgroundColor'],
    json['designElement'],
  )..groupNode = json['groupNode'];
}

Map<String, dynamic> _$ArtboardToJson(Artboard instance) => <String, dynamic>{
      'backgroundColor': instance.backgroundColor,
      'designElement': instance.designElement,
      'groupNode': instance.groupNode,
    };
