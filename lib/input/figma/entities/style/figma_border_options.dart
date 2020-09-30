import 'package:parabeac_core/design_logic/pb_border_options.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/input/figma/entities/style/figma_border.dart';

part 'figma_border_options.g.dart';

@JsonSerializable()
class FigmaBorderOptions implements PBBorderOptions {
  @override
  // TODO: implement dashPattern
  List get dashPattern => throw UnimplementedError();

  @override
  // TODO: implement isEnabled
  bool get isEnabled => throw UnimplementedError();

  @override
  // TODO: implement lineCapStyle
  int get lineCapStyle => throw UnimplementedError();

  @override
  // TODO: implement lineJoinStyle
  int get lineJoinStyle => throw UnimplementedError();

  FigmaBorderOptions();

  Map<String, dynamic> toJson() => _$FigmaBorderOptionsToJson(this);

  factory FigmaBorderOptions.fromJson(Map<String, dynamic> json) =>
      _$FigmaBorderOptionsFromJson(json);
}
