import 'auto_layout_test.dart' as auto_layout_test;
import 'global_styling_test.dart' as global_styling_test;
import 'styling_test.dart' as styling_test;

void main(List<String> args) {
  /// TODO: When we add more tests, here we can run parabeac core and pass as arguments
  /// the location of the generated file as parameter.
  auto_layout_test.main();
  global_styling_test.main();
  styling_test.main(); // TODO: Pass arguments
}
