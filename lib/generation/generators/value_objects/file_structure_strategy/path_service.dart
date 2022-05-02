abstract class PathService {
  PathService();

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
  static final String viewsRelativePath = 'lib/views';
  static final String widgetsRelativePath = 'lib/widgets';
  static final String customrelativePath = '$widgetsRelativePath/custom';

  DomainPathService() : super();
}
