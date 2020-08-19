import 'package:json_annotation/json_annotation.dart';
part 'paragraph_style.g.dart';

@JsonSerializable(nullable: true)
class ParagraphStyle {
  int alignment;

  ParagraphStyle({this.alignment});

  factory ParagraphStyle.fromJson(Map<String,dynamic> json) => _$ParagraphStyleFromJson(json);

  Map<String,dynamic> toJson() => _$ParagraphStyleToJson(this);
}
