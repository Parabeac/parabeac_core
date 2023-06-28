import 'package:get_it/get_it.dart';
import 'package:parabeac_core/analytics/amplitude_analytics_service.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/layout_properties.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

abstract class PBLayoutGenerator extends PBGenerator {
  PBLayoutGenerator() : super();

  @override
  String generate(PBIntermediateNode source, PBContext generatorContext);

  String layoutTemplate(source, String type, PBContext context) {
    var buffer = StringBuffer();
    var children = context.tree.childrenOf(source);
    // Write the type of Layout, Column or Row
    buffer.write('$type(');
    if (children.isNotEmpty) {
      var layoutProperties = source.layoutProperties;

      // Write the different kinds of alignments
      // that a layout could have
      buffer.write(getAlignments(layoutProperties));

      // Write all children
      buffer.write(getChildren(children, context));

      buffer.write(')');
    }
    // Add number of auto layouts to analytics
    if (!context.tree.lockData) {
      GetIt.I.get<AmplitudeService>().addToAnalytics('Number of auto layouts');
    }
    return buffer.toString();
  }

  String getChildren(Set<PBIntermediateNode> children, PBContext context) {
    var buffer = StringBuffer();
    buffer.write('\nchildren: [');
    // Iterate through all the children
    // and generate them
    for (var index = 0; index < children.length; index++) {
      var element = children
          .elementAt(index)
          .generator
          .generate(children.elementAt(index), context);
      buffer.write(element);
      var endingChar = element != null && element.isEmpty ? '' : ',';
      buffer.write(endingChar);
    }
    buffer.write(']');

    return buffer.toString();
  }

  String getAlignments(LayoutProperties layoutProperties) {
    var buffer = StringBuffer();
    if (layoutProperties != null) {
      // Write main axis alignment if need it
      if (layoutProperties.primaryAxisAlignment != null) {
        buffer.write(
            'mainAxisAlignment: MainAxisAlignment.${getAlignmentString(layoutProperties.primaryAxisAlignment)},');
      }
      // Write cross axis alignment if need it
      if (layoutProperties.crossAxisAlignment != null) {
        buffer.write(
            'crossAxisAlignment: CrossAxisAlignment.${getAlignmentString(layoutProperties.crossAxisAlignment)},');
      }
      // Write main axis sizing if need it
      if (layoutProperties.primaryAxisSizing != null &&
          layoutProperties.primaryAxisSizing == IntermediateAxisMode.HUGGED) {
        buffer.write('mainAxisSize: MainAxisSize.min,');
      }
    }
    return buffer.toString();
  }

  /// Gets the string form of [alignment]
  String getAlignmentString(IntermediateAxisAlignment alignment) {
    switch (alignment) {
      case IntermediateAxisAlignment.SPACE_BETWEEN:
        return 'spaceBetween';
        break;
      default:
        return alignment.toString().split('.').last.toLowerCase();
    }
  }
}
