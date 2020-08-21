import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/pb_page_writer.dart';
import 'package:parabeac_core/generation/generators/pb_param.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_bitmap_gen.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_shape_group_gen.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_spacer_gen.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_text_gen.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_gen_cache.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

import 'pb_param.dart';

/**
 * The caller of the method `generate()` is going to look at the configurations and decide if the page is
 * going to become `STATEFUL_WIDGET` or `STATELESS_WIDGET`.
 */
abstract class PBGenerationManager {
  // final bool debug;
  List<PBGenerator> _registeredGenerators = [
    PBTextGen(),
    PBBitmapGenerator(),
    PBSpacerGenerator(),
    PBShapeGroupGen(),
  ];
  // final PBSymbolModel _symbolModel = PBSymbolModel();

  ///* In charge of who will write the output of the file
  PBPageWriter pageWriter;
  // PBContext context;

  ///* Keep track of the imports the current page may have
  List<String> imports = [];

  ///* Keep track of the current page body
  StringBuffer body;

  ///* Keep track of the instance variable a class may have
  /// I think the following three may be only for Flutter (?)

  List<PBParam> constructorVariables = [];
  List<PBParam> instanceVariables = [];
  Map<String, String> dependencies = {};

  PBGenerationManager(
    this.pageWriter,
  );
  void addImport(String value);

  void addToConstructor(PBParam parameter);

  String generate(PBIntermediateNode rootNode, {type});

  String addDependencies(String packageName, String version);

  String getPath(String uuid) => PBGenCache().getPath(uuid);

  void addConstructorVariable(PBParam param);

  void addInstanceVariable(PBParam variable);
}
