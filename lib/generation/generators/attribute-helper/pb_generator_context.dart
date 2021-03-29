/// This class is responsible for sharing contextual data needed throughout the generation process. Generators will pass this information to it's children.
class GeneratorContext {
  SizingValueContext sizingContext = SizingValueContext.PointValue;

  GeneratorContext({
    this.sizingContext,
  });
}

enum SizingValueContext {
  PointValue,
  MediaQueryValue,
  LayoutBuilderValue,
  AppBarChild,
}
