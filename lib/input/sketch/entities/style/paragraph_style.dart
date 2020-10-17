import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/design_logic/pb_paragraph_style.dart';
part 'paragraph_style.g.dart';

@JsonSerializable(nullable: true)
class ParagraphStyle implements PBParagraphStyle {
  @override
  int alignment;

  ParagraphStyle({this.alignment});

  factory ParagraphStyle.fromJson(Map<String, dynamic> json) =>
      _$ParagraphStyleFromJson(json);

  Map<String, dynamic> toJson() => _$ParagraphStyleToJson(this);
}
