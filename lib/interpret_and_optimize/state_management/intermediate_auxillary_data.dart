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
  @JsonKey(name: 'fills')
  List<PBFill> colors;

  /// Info relating to a elements borders.
  @JsonKey(name: 'borderOptions')
  IntermediateBorderInfo borderInfo;

  /// Effect for widgets
  List<PBEffect> effects;

  /// Style for text
  @JsonKey(name: 'textStyle')
  PBTextStyle intermediateTextStyle;

  /// Blended color
  @JsonKey(ignore: true)
  PBColor color;

  IntermediateAuxiliaryData({
    this.colors,
    this.borderInfo,
    this.effects,
    this.intermediateTextStyle,
  }) {
    if (colors != null) {
      color = _calculateBlendColor();
    }
  }

  factory IntermediateAuxiliaryData.fromJson(Map<String, dynamic> json) =>
      _$IntermediateAuxiliaryDataFromJson(json);

  Map<String, dynamic> toJson() => _$IntermediateAuxiliaryDataToJson(this);

  // Calculate just one color from all fills
  PBColor _calculateBlendColor() {
    var tempColor = [];
    if (colors.isNotEmpty) {
      colors.forEach((fill) {
        if (fill.isEnabled) {
          if (fill.type == 'SOLID') {
            if (tempColor.isEmpty) {
              tempColor = _colorToList(fill);
            } else {
              var temp = _colorToList(fill);
              tempColor = _addColors(tempColor, temp);
            }
          }
        }
      });
      // In case tempColor never gets data
      if (tempColor.isEmpty) {
        return null;
      }
      return PBColor(tempColor[3], tempColor[0], tempColor[1], tempColor[2]);
    }
    // In case colors is empty
    else {
      return null;
    }
  }

  // This method takes two PBDL Colors in list form and adds them
  List<double> _addColors(List<double> base, List<double> added) {
    var tempColor = <double>[];

    var calculatedPercentage = (added[3] + base[3]) / 100;

    var addedPercentage = (added[3] / calculatedPercentage) / 100;

    var basePercentage = (base[3] / calculatedPercentage) / 100;

    var calculatedAlpha = 1 - (1 - added[3]) * (1 - base[3]);

    tempColor.add((added[0] * addedPercentage) + (base[0] * basePercentage));
    tempColor.add((added[1] * addedPercentage) + (base[1] * basePercentage));
    tempColor.add((added[2] * addedPercentage) + (base[2] * basePercentage));
    tempColor.add(calculatedAlpha);

    return tempColor;
  }

  // Returns a pbdl fill to a list of double
  List<double> _colorToList(PBFill fill) {
    var alpha = _getAlpha(fill.opacity);
    var temp = <double>[];
    temp.add(fill.color.r);
    temp.add(fill.color.g);
    temp.add(fill.color.b);
    temp.add(alpha);
    return temp;
  }

  // Calculates the alpha of a fill
  double _getAlpha(num opacity) {
    if (opacity > 1) {
      return (opacity / 100).toDouble();
    } else {
      return opacity.toDouble();
    }
  }
}
