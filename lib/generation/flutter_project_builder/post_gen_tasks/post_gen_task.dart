import 'package:parabeac_core/controllers/main_info.dart';

/// Abstract class for Tasks that will run post-generation.
abstract class PostGenTask {
  /// Executes the [PostGenTask].
  void execute();
}
