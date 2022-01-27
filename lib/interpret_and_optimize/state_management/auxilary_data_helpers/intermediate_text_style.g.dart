// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intermediate_text_style.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PBTextStyle _$PBTextStyleFromJson(Map<String, dynamic> json) {
  return PBTextStyle(
    fontFamily: json['fontFamily'] as String,
    fontPostScriptName: json['fontPostScriptName'] as String,
    paragraphSpacing: json['paragraphSpacing'] as num ?? 0,
    paragraphIndent: json['paragraphIndent'] as num ?? 0,
    listSpacing: json['listSpacing'] as num ?? 0,
    italics: json['italics'] as bool,
    fontWeight: json['fontWeight'] as num,
    fontSize: json['fontSize'] as num,
    textCase: json['textCase'] as String ?? 'ORIGINAL',
    textDecoration: json['textDecoration'] as String ?? 'NONE',
    textAutoResize: json['textAutoResize'] as String ?? 'NONE',
    textAlignHorizontal: json['textAlignHorizontal'] as String,
    textAlignVertical: json['textAlignVertical'] as String,
    letterSpacing: json['letterSpacing'] as num,
    fills: (json['fills'] as List)
        ?.map((e) =>
            e == null ? null : PBDLFill.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    hyperLink: json['hyperLink'] as String,
    opentypeFlags: (json['opentypeFlags'] as Map<String, dynamic>)?.map(
          (k, e) => MapEntry(k, e as num),
        ) ??
        {},
    lineHeightPx: json['lineHeightPx'] as num,
    lineHeightPercent: json['lineHeightPercent'] as num ?? 100,
    lineHeightPercentFontSize: json['lineHeightPercentFontSize'] as num,
    lineHeightUnit: json['lineHeightUnit'] as String,
  );
}

Map<String, dynamic> _$PBTextStyleToJson(PBTextStyle instance) =>
    <String, dynamic>{
      'fontFamily': instance.fontFamily,
      'fontPostScriptName': instance.fontPostScriptName,
      'paragraphSpacing': instance.paragraphSpacing,
      'paragraphIndent': instance.paragraphIndent,
      'listSpacing': instance.listSpacing,
      'italics': instance.italics,
      'fontWeight': instance.fontWeight,
      'fontSize': instance.fontSize,
      'textCase': instance.textCase,
      'textDecoration': instance.textDecoration,
      'textAutoResize': instance.textAutoResize,
      'textAlignHorizontal': instance.textAlignHorizontal,
      'textAlignVertical': instance.textAlignVertical,
      'letterSpacing': instance.letterSpacing,
      'fills': instance.fills?.map((e) => e?.toJson())?.toList(),
      'hyperLink': instance.hyperLink,
      'opentypeFlags': instance.opentypeFlags,
      'lineHeightPx': instance.lineHeightPx,
      'lineHeightPercent': instance.lineHeightPercent,
      'lineHeightPercentFontSize': instance.lineHeightPercentFontSize,
      'lineHeightUnit': instance.lineHeightUnit,
    };
