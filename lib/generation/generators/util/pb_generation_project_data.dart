import 'package:parabeac_core/generation/generators/writers/pb_flutter_writer.dart';
import 'package:parabeac_core/generation/semi_constant_templates/semi_constant_template.dart';

class PBGenerationProjectData {
  // List of current templates on the project
  List<SemiConstantTemplate> templates = [];

  // Add template to the project
  // only if the template is not already part of
  // current project's templates
  void addTemplate(SemiConstantTemplate template) {
    if (!templates
        .any((element) => element.runtimeType == template.runtimeType)) {
      templates.add(template);
    }
  }

  void addDependencies(String packageName, String version) =>
      PBFlutterWriter().addDependency(packageName, version);
}
