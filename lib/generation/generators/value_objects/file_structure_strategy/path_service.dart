abstract class PathService {
  final String viewsRelativePath;
  final String widgetsRelativePath;
  final String customRelativePath;
  final String constantsRelativePath;
  PathService(
    this.viewsRelativePath,
    this.widgetsRelativePath,
    this.customRelativePath,
    this.constantsRelativePath,
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
  static final String _widgetsPath = 'lib/widgets';

  @override
  final String viewsRelativePath = 'lib/views';
  @override
  final String widgetsRelativePath = '$_widgetsPath';
  @override
  final String customRelativePath = '$_widgetsPath/custom';
  @override
  final String constantsRelativePath = 'lib/constants';

  DomainPathService({
    String viewsRelativePath,
    String widgetsRelativePath,
    String customRelativePath,
    String constantsRelativePath,
  }) : super(
          viewsRelativePath,
          widgetsRelativePath,
          customRelativePath,
          constantsRelativePath,
        );
}
