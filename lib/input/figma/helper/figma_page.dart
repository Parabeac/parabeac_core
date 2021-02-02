import 'package:parabeac_core/input/helper/design_page.dart';
import 'package:quick_log/quick_log.dart';

class FigmaPage extends DesignPage {
  @override
  var log = Logger('FigmaPage');
  FigmaPage(String name, String id)
      : super(
          name: name,
          id: id,
        );
}
