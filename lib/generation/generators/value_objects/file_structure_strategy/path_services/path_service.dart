import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/path_services/domain_path_service.dart';

/// PathService class helps file writers commands to determine
/// the right path for their views, widgets, custom and constants
/// by centralizing the path to this class
///
/// The class can be extended to create different types of PathService
/// by default we made [DomainPathService]
abstract class PathService {
  final String viewsRelativePath;
  final String widgetsRelativePath;
  final String customRelativePath;
  final String constantsRelativePath;
  final String themingRelativePath;
  PathService(
    this.viewsRelativePath,
    this.widgetsRelativePath,
    this.customRelativePath,
    this.constantsRelativePath,
    this.themingRelativePath,
  );

  factory PathService.fromConfiguration(String architecture) {
    // TODO: Once we add more if statements, we can declare `domain` case as the else statement
    if (architecture.toLowerCase() == 'domain') {
      return DomainPathService();
    }

    /// If no architecture is set
    /// we will return DomainPathService as default
    return DomainPathService();
  }
}
