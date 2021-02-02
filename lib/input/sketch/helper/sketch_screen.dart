import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/input/helper/design_screen.dart';

class SketchScreen extends DesignScreen {
  SketchScreen(
    DesignNode root,
    String id,
    String name,
  ) : super(
          designNode: root,
          id: id,
          name: name,
        );
}
