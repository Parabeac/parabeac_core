// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'foreign_symbol.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForeignSymbol _$ForeignSymbolFromJson(Map<String, dynamic> json) {
  return ForeignSymbol(
    do_objectID: json['do_objectID'],
    libraryID: json['libraryID'],
    sourceLibraryName: json['sourceLibraryName'] as String,
    symbolPrivate: json['symbolPrivate'] as bool,
    originalMaster: json['originalMaster'] == null
        ? null
        : SymbolMaster.fromJson(json['originalMaster'] as Map<String, dynamic>),
    symbolMaster: json['symbolMaster'] == null
        ? null
        : SymbolMaster.fromJson(json['symbolMaster'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ForeignSymbolToJson(ForeignSymbol instance) =>
    <String, dynamic>{
      'do_objectID': instance.do_objectID,
      'libraryID': instance.libraryID,
      'sourceLibraryName': instance.sourceLibraryName,
      'symbolPrivate': instance.symbolPrivate,
      'originalMaster': instance.originalMaster,
      'symbolMaster': instance.symbolMaster,
    };
