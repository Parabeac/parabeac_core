import 'package:parabeac_core/interpret_and_optimize/state_management/auxilary_data_helpers/intermediate_border_info.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_color.dart';
import 'package:json_annotation/json_annotation.dart';

import 'auxilary_data_helpers/intermediate_effect.dart';
import 'auxilary_data_helpers/intermediate_fill.dart';
import 'auxilary_data_helpers/intermediate_text_style.dart';

part 'intermediate_auxillary_data.g.dart';

@JsonSerializable(explicitToJson: true)
class IntermediateAuxiliaryData {
  /// Info relating to the alignment of an element, currently just in a map format.
  Map alignment;

  /// All colors that may be needed
  List<PBFill> colors;

  /// Info relating to a elements borders.
  @JsonKey(ignore: true)
  PBBorderInfo borderInfo;

  /// Effect for widgets
  List<PBEffect> effects;

  /// Style for text
  PBTextStyle intermediateTextStyle;

  @JsonKey(ignore: true)
  PBColor get color => _getColor();

  PBColor _getColor() {
    if (colors != null && colors.isNotEmpty) {
      return colors.first.color;
    } else {
      return null;
    }
  }

  IntermediateAuxiliaryData({
    this.colors,
    this.borderInfo,
    this.effects,
    this.intermediateTextStyle,
  });

  factory IntermediateAuxiliaryData.fromJson(Map<String, dynamic> json) =>
      _$IntermediateAuxiliaryDataFromJson(json);

  Map<String, dynamic> toJson() => _$IntermediateAuxiliaryDataToJson(this);
}
