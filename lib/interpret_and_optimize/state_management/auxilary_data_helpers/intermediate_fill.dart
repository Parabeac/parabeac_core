import 'dart:math';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_color.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_image_reference_storage.dart';

part 'intermediate_fill.g.dart';

@JsonSerializable(explicitToJson: true)
class PBFill {
  List<PBGradientStop> gradientStops;
  @JsonKey(fromJson: _pointsFromJson, toJson: _pointsToJson)
  List<Point> gradientHandlePositions;

  // String that identifies the ID of the image
  String imageRef;

  PBColor color;

  @JsonKey(defaultValue: 100)
  num opacity;

  String blendMode;

  String type;

  @JsonKey(defaultValue: true)
  bool isEnabled;

  final pbdlType = 'fill';

  PBFill({
    this.opacity,
    this.blendMode,
    this.type,
    this.isEnabled,
    this.color,
    this.imageRef,
  }) {
    if (imageRef != null && imageRef.isNotEmpty) {
      ImageReferenceStorage().addReference(imageRef.replaceAll('images/', ''),
          '${MainInfo().outputPath}assets/images');
    }
  }

  @override
  factory PBFill.fromJson(Map<String, dynamic> json) => _$PBFillFromJson(json);

  Map<String, dynamic> toJson() => _$PBFillToJson(this);

  static List<Point> _pointsFromJson(List points) {
    var objPoints = <Point>[];
    for (var point in points) {
      objPoints.add(Point(point['x'], point['y']));
    }
    return objPoints;
  }

  static List<Map> _pointsToJson(List<Point> points) {
    var maps = <Map>[];
    if (points != null) {
      for (var p in points) {
        maps.add({'x': p.x, 'y': p.y});
      }
    }
    return maps;
  }

  String constantGenerator() {
    if (imageRef != null) {
      return 'Image.asset(\'$imageRef\')';
    } else if (type.toLowerCase().contains('gradient')) {
      return 'Gradient()';
    }
    return '//TODO';
  }
}

@JsonSerializable()
class PBGradientStop {
  PBColor color;
  num position;

  PBGradientStop({
    this.color,
    this.position,
  });

  factory PBGradientStop.fromJson(Map<String, dynamic> json) =>
      _$PBGradientStopFromJson(json);

  Map<String, dynamic> toJson() => _$PBGradientStopToJson(this);
}
