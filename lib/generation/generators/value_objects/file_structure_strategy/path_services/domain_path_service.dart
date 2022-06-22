import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/path_services/path_service.dart';

class DomainPathService extends PathService {
  DomainPathService({
    String viewsRelativePath = 'lib/views',
    String widgetsRelativePath = 'lib/widgets',
    String customRelativePath = 'custom',
    String constantsRelativePath = 'lib/constants',
    String themingRelativePath = 'lib/theme',
  }) : super(
          viewsRelativePath,
          widgetsRelativePath,
          customRelativePath,
          constantsRelativePath,
          themingRelativePath,
        );
}
