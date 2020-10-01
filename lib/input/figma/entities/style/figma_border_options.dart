import 'package:parabeac_core/design_logic/pb_border_options.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/input/figma/entities/style/figma_border.dart';

part 'figma_border_options.g.dart';

@JsonSerializable()
class FigmaBorderOptions implements PBBorderOptions {
  @override
  List dashPattern;

  @override
  bool isEnabled;

  @override
  int lineCapStyle;

  @override
  int lineJoinStyle;

  FigmaBorderOptions(
    this.dashPattern,
    this.isEnabled,
    this.lineCapStyle,
    this.lineJoinStyle,
  );

  Map<String, dynamic> toJson() => _$FigmaBorderOptionsToJson(this);

  factory FigmaBorderOptions.fromJson(Map<String, dynamic> json) =>
      _$FigmaBorderOptionsFromJson(json);
}
