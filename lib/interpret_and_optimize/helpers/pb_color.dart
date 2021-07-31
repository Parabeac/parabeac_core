import 'package:hex/hex.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/index_walker.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pb_color.g.dart';

@JsonSerializable()
class PBColor {
  num alpha;
  num red;
  num green;
  num blue;

  PBColor(
    this.alpha,
    this.red,
    this.green,
    this.blue,
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
      a = ((color.alpha ?? 0) * 255).round();
      r = ((color.red ?? 0) * 255).round();
      g = ((color.green ?? 0) * 255).round();
      b = ((color.blue ?? 0) * 255).round();
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

  /// Returns a json representation of color assuming we receive a PBSL `style` in json format
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
}
