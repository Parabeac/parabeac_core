import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/input/sketch/entities/style/color.dart';
import 'package:parabeac_core/input/sketch/entities/style/context_settings.dart';
import 'package:parabeac_core/input/sketch/entities/style/gradient.dart';
import 'package:parabeac_core/design_logic/pb_border.dart';
part 'border.g.dart';

@JsonSerializable(nullable: true)
class Border implements PBBorder{
  @JsonKey(name: '_class')
  final String classField;
  @override
  final bool isEnabled;
  @override
  final double fillType;
  @override
  final Color color;
  final ContextSettings contextSettings;
  final Gradient gradient;
  final double position;
  @override
  final double thickness;

  Border(
      {this.classField,
      this.color,
      this.contextSettings,
      this.fillType,
      this.gradient,
      this.isEnabled,
      this.position,
      this.thickness});

  factory Border.fromJson(Map json) => _$BorderFromJson(json);
  @override
  Map toJson() => _$BorderToJson(this);
}
