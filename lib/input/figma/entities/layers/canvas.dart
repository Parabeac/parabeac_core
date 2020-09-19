import 'package:json_annotation/json_annotation.dart';

part 'canvas.g.dart';

@JsonSerializable(nullable: true)
class Canvas {
  Canvas();

  String id;
  String name;
  String type;

  dynamic children;

  dynamic backgroundColor;

  dynamic prototypeStartNodeID;

  dynamic prototypeDevice;

  dynamic exportSettings;

  Canvas createSketchNode(Map<String, dynamic> json) => Canvas.fromJson(json);
  factory Canvas.fromJson(Map<String, dynamic> json) => _$CanvasFromJson(json);

  Map<String, dynamic> toJson() => _$CanvasToJson(this);
}
