import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';

/// This class is responsible for sharing contextual data needed throughout the generation process. Generators will pass this information to it's children.
class GeneratorContext {
  SizingValueContext sizingContext = SizingValueContext.PointValue;
  List<PBSharedParameterProp> overridableProperties = [];

  GeneratorContext({this.sizingContext, this.overridableProperties});
}

enum SizingValueContext {
  PointValue,
  MediaQueryValue,
  LayoutBuilderValue,
  AppBarChild,
}
