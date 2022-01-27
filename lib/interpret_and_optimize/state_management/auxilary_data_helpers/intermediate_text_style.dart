import 'package:pbdl/pbdl.dart';

import 'package:json_annotation/json_annotation.dart';

part 'intermediate_text_style.g.dart';

@JsonSerializable(explicitToJson: true)
class PBTextStyle {
  String fontFamily;

  String fontPostScriptName;

  @JsonKey(defaultValue: 0)
  num paragraphSpacing;

  @JsonKey(defaultValue: 0)
  num paragraphIndent;

  @JsonKey(defaultValue: 0)
  num listSpacing;

  bool italics;

  num fontWeight;

  num fontSize;

  @JsonKey(defaultValue: 'ORIGINAL')
  String textCase;

  @JsonKey(defaultValue: 'NONE')
  String textDecoration;

  @JsonKey(defaultValue: 'NONE')
  String textAutoResize;

  String textAlignHorizontal;

  String textAlignVertical;

  num letterSpacing;

  List<PBDLFill> fills;

  String hyperLink;

  @JsonKey(defaultValue: {})
  Map<String, num> opentypeFlags;

  num lineHeightPx;

  @JsonKey(defaultValue: 100)
  num lineHeightPercent;

  num lineHeightPercentFontSize;

  String lineHeightUnit;

  @override
  final pbdlType = 'text_style';

  PBTextStyle({
    this.fontFamily,
    this.fontPostScriptName,
    this.paragraphSpacing,
    this.paragraphIndent,
    this.listSpacing,
    this.italics,
    this.fontWeight,
    this.fontSize,
    this.textCase,
    this.textDecoration,
    this.textAutoResize,
    this.textAlignHorizontal,
    this.textAlignVertical,
    this.letterSpacing,
    this.fills,
    this.hyperLink,
    this.opentypeFlags,
    this.lineHeightPx,
    this.lineHeightPercent,
    this.lineHeightPercentFontSize,
    this.lineHeightUnit,
  });

  @override
  factory PBTextStyle.fromJson(Map<String, dynamic> json) =>
      _$PBTextStyleFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$PBTextStyleToJson(this);
}
