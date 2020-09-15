import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/input/sketch/entities/style/color.dart';
import 'package:parabeac_core/input/sketch/entities/style/context_settings.dart';
import 'package:parabeac_core/input/sketch/entities/style/gradient.dart';
part 'fill.g.dart';

@JsonSerializable(nullable: true)
class Fill {
  @JsonKey(name: '_class')
  final String classField;
  final bool isEnabled;
  final int fillType;
  final Color color;
  final ContextSettings contextSettings;
  final Gradient gradient;
  final int noiseIndex;
  final int noiseIntensity;
  final int patternFillType;
  final int patternTileScale;

  Fill(
      {this.classField,
      this.color,
      this.contextSettings,
      this.fillType,
      this.gradient,
      this.isEnabled,
      this.noiseIndex,
      this.noiseIntensity,
      this.patternFillType,
      this.patternTileScale});

  factory Fill.fromJson(Map json) => _$FillFromJson(json);
  Map toJson() => _$FillToJson(this);
}
