/// This class is responsible for sharing contextual data needed throughout the generation process. Generators will pass this information to it's children.
class GeneratorContext {
  GeneratorContext({this.sizingContext});
  SizingValueContext sizingContext = SizingValueContext.PointValue;
}

enum SizingValueContext {
  PointValue,
  MediaQueryValue,
  LayoutBuilderValue,
  AppBarChild,
}
