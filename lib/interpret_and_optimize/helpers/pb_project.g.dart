// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pb_project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBProject _$PBProjectFromJson(Map<String, dynamic> json) {
  return PBProject(
    json['name'] as String,
    json['projectAbsPath'] as String,
  )..forest =
      PBProject.forestFromJson(json['pages'] as List<Map<String, dynamic>>);
}

Map<String, dynamic> _$PBProjectToJson(PBProject instance) => <String, dynamic>{
      'name': instance.projectName,
      'projectAbsPath': instance.projectAbsPath,
      'pages': instance.forest?.map((e) => e?.toJson())?.toList(),
    };
