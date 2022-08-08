import 'package:parabeac_core/controllers/main_info.dart';

/// Abstract class for Tasks that will run post-generation.
abstract class PostGenTask {
  /// Executes the [PostGenTask].
  void execute();

  // Add elements to analytics
  void addToAnalytics(String propertyName) {
    if (MainInfo().amplitudMap['eventProperties'].containsKey(propertyName)) {
      MainInfo().amplitudMap['eventProperties'][propertyName]++;
    } else {
      MainInfo().amplitudMap['eventProperties'][propertyName] = 1;
    }
  }
}
