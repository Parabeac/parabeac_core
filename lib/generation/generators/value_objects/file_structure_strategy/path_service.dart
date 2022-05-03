abstract class PathService {
  final String viewsRelativePath;
  final String widgetsRelativePath;
  final String customRelativePath;
  PathService(
    this.viewsRelativePath,
    this.widgetsRelativePath,
    this.customRelativePath,
  );

  factory PathService.fromConfiguration(String architecture) {
    if (architecture.toLowerCase() == 'domain') {
      return DomainPathService();
    }

    /// If no architecture is set
    /// we will return DomainPathService as default
    return DomainPathService();
  }
}

class DomainPathService extends PathService {
  static String viewsPath = 'lib/views';

  @override
  final String viewsRelativePath = '$viewsPath';
  @override
  final String widgetsRelativePath = 'lib/widgets';
  @override
  final String customRelativePath = '$viewsPath/custom';

  DomainPathService({
    String viewsRelativePath,
    String widgetsRelativePath,
    String customRelativePath,
  }) : super(
          viewsRelativePath,
          widgetsRelativePath,
          customRelativePath,
        );
}
