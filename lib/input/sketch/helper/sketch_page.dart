import 'package:parabeac_core/input/helper/design_page.dart';
import 'package:quick_log/quick_log.dart';

class SketchPage extends DesignPage {
  @override
  var log = Logger('Design Page Sketch');

  SketchPage(String name, String id)
      : super(
          name: name,
          id: id,
        );
}
