import 'package:parabeac_core/input/sketch/entities/style/font_descriptor.dart';

abstract class PBPageWriter {
  Map<String, String> dependencies = {};
  Map<String, Map<String,FontDescriptor>> fonts = {};
  void write(String code, String fileName);

  void addDependency(String packageName, String version);
  void addFont(FontDescriptor fd);
}
