import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

/// Abstract class for Generatiion Services
/// so they all have the current context
abstract class PBGenerationService {
  PBContext currentContext;

  PBGenerationService({this.currentContext});
}
