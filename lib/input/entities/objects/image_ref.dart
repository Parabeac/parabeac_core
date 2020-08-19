import 'package:json_annotation/json_annotation.dart';

part 'image_ref.g.dart';

@JsonSerializable(nullable: true)
///Referenfece of an image according to Sketch' schema
class ImageRef{

  @JsonKey(name: '_ref')
  final String reference;

  ImageRef(this.reference);
  factory ImageRef.fromJson(Map<String, dynamic> json) => _$ImageRefFromJson(json);
  Map<String, dynamic> toJson() => _$ImageRefToJson(this);
}