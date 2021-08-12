import 'package:parabeac_core/interpret_and_optimize/entities/intermediate_border_info.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_color.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/directed_state_graph.dart';
import 'package:json_annotation/json_annotation.dart';

part 'intermediate_auxillary_data.g.dart';

@JsonSerializable(explicitToJson: true)
class IntermediateAuxiliaryData {
  @JsonKey(ignore: true)
  DirectedStateGraph stateGraph;

  /// Info relating to the alignment of an element, currently just in a map format.
  Map alignment;

  /// Info relating to a elements borders.
  @JsonKey(ignore: true)
  IntermediateBorderInfo borderInfo;

  /// The background color of the element.
  @JsonKey(fromJson: ColorUtils.pbColorFromJsonFills, name: 'fills')
  PBColor color;

  IntermediateAuxiliaryData({
    this.stateGraph,
    this.color,
  }) {
    stateGraph ??= DirectedStateGraph();
  }

  factory IntermediateAuxiliaryData.fromJson(Map<String, dynamic> json) =>
      _$IntermediateAuxiliaryDataFromJson(json)
        ..borderInfo = json['borders'].isNotEmpty
            ? IntermediateBorderInfo.fromJson(json['borders'][0])
            : IntermediateBorderInfo(
                isBorderOutlineVisible: false, borderRadius: 0);

  Map<String, dynamic> toJson() => _$IntermediateAuxiliaryDataToJson(this);
}
