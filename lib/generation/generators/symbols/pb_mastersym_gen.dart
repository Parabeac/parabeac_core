import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/value_objects/pb_template_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:quick_log/quick_log.dart';

class PBMasterSymbolGenerator extends PBGenerator {
  PBMasterSymbolGenerator() : super(strategy: StatelessTemplateStrategy());

  var log = Logger('Symbol Master Generator');
  @override
  String generate(PBIntermediateNode source) {
    var buffer = StringBuffer();
    if (source is PBSharedMasterNode) {
      if (source.child == null) {
        return '';
      }
      var name;
      try {
        //Remove any special characters and leading numbers from the method name
        name = source.name
            .replaceAll(RegExp(r'[^\w]+'), '')
            .replaceFirst(RegExp(r'^[\d]+'), '');
        //Make first letter of method name capitalized
        name = name[0].toLowerCase() + name.substring(1);
      } catch (e, stackTrace) {
        MainInfo().sentry.captureException(
              exception: e,
              stackTrace: stackTrace,
            );
        log.error(e.toString());
      }

      var generatedWidget = manager.generate(source.child);
      if (generatedWidget == null || generatedWidget.isEmpty) {
        return '';
      }
      buffer.write(generatedWidget);
      return buffer.toString();
    }
  }
}
