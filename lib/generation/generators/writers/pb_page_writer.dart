abstract class PBPageWriter {
  Map<String, String> dependencies = {};
  void write(String code, String fileName);

  void append(String code, String fileName);

  void addDependency(String packageName, String version);
}
