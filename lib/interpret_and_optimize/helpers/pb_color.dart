import 'package:hex/hex.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/index_walker.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pb_color.g.dart';

@JsonSerializable()
class PBColor {
  num a;
  num r;
  num g;
  num b;

  PBColor(
    this.a,
    this.r,
    this.g,
    this.b,
  );

  factory PBColor.fromJson(Map<String, dynamic> json) =>
      _$PBColorFromJson(json);

  Map<String, dynamic> toJson() => _$PBColorToJson(this);

  @override
  String toString() => ColorUtils.toHex(this);
}

class ColorUtils {
  static String toHex(PBColor color) {
    if (color != null) {
      int a, r, g, b;
      a = ((color.a ?? 0) * 255).round();
      r = ((color.r ?? 0) * 255).round();
      g = ((color.g ?? 0) * 255).round();
      b = ((color.b ?? 0) * 255).round();
      return '0x' + HEX.encode([a, r, g, b]);
    } else {
      return '0x' + HEX.encode([0, 0, 0, 0]);
    }
  }

  static String findDefaultColor(String hex) {
    switch (hex) {
      case '0xffffffff':
        return 'Colors.white';
        break;
      case '0xff000000':
        return 'Colors.black';
        break;
    }
    return null;
  }

  /// Returns a json representation of color assuming we receive a PBDL `style` in json format
  static PBColor pbColorFromJsonFills(List<Map<String, dynamic>> json) {
    var fills = IndexWalker(json).value;

    if (fills != null && fills.isNotEmpty) {
      // Get first fill that has a color and is enabled
      var fill = fills.firstWhere(
          (fill) => fill['isEnabled'] as bool && fill['color'] != null,
          orElse: () => null);

      if (fill != null) {
        return PBColor.fromJson(fill['color']);
      }
    }
    return null;
  }

  // static List<PBColor> getColorListFromJsonFIlls(List<Map<String, dynamic>> json){
  //   var tempList = <PBColor>[];

  //   for(var fill in json){
  //     tempList
  //   }

  //   return tempList;
  // }
}
