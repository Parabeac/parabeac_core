// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pb_project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBProject _$PBProjectFromJson(Map<String, dynamic> json) {
  return PBProject(
    json['name'] as String,
    json['projectAbsPath'] as String,
    json['sharedStyles'] as List,
  )
    ..lockData = json['lockData'] as bool
    ..forest = (json['forest'] as List)
        ?.map((e) => e == null
            ? null
            : PBIntermediateTree.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$PBProjectToJson(PBProject instance) => <String, dynamic>{
      'name': instance.projectName,
      'projectAbsPath': instance.projectAbsPath,
      'lockData': instance.lockData,
      'forest': instance.forest?.map((e) => e?.toJson())?.toList(),
      'sharedStyles': instance.sharedStyles,
    };
