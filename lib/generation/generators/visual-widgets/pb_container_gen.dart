import 'package:parabeac_core/generation/generators/attribute-helper/pb_box_decoration_gen_helper.dart';
import 'package:parabeac_core/generation/generators/attribute-helper/pb_color_gen_helper.dart';
import 'package:parabeac_core/generation/generators/attribute-helper/pb_size_helper.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/injected_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'dart:math';

class PBContainerGenerator extends PBGenerator {
  String color;

  PBContainerGenerator() : super();

  @override
  String generate(PBIntermediateNode source, PBContext context) {
    if (source is PBContainer) {
      var sourceChildren = context.tree.childrenOf(source);
      var buffer = StringBuffer();
      buffer.write('Container(');

      //TODO(ivanV): please clean my if statement :(
      if (source is InjectedContainer) {
        if (source.padding != null) {
          buffer.write(getPadding(source.padding));
        }
        if (source.pointValueHeight &&
            source.frame.height > 0 &&
            source.showHeight) {
          buffer.write('height: ${source.frame.height},');
        }
        if (source.pointValueWidth &&
            source.frame.width > 0 &&
            source.showWidth) {
          buffer.write('width: ${source.frame.width},');
        }
        if (!source.pointValueHeight && !source.pointValueWidth) {
          buffer.write(PBSizeHelper().generate(source, context));
        }
      } else if (source is InheritedContainer) {
        if (source.padding != null) {
          buffer.write(getPadding(source.padding));
        }
        buffer.write(PBSizeHelper().generate(source, context));
      }

      if (source.auxiliaryData.borderInfo != null) {
        buffer.write(PBBoxDecorationHelper().generate(source, context));
      } else {
        buffer.write(PBColorGenHelper().generate(source, context));
      }

      // if (source.auxiliaryData.alignment != null) {
      //   buffer.write(
      //       'alignment: Alignment(${(source.auxiliaryData.alignment['alignX'] as double).toStringAsFixed(2)}, ${(source.auxiliaryData.alignment['alignY'] as double).toStringAsFixed(2)}),');
      // }
      var child = sourceChildren.isEmpty ? null : sourceChildren.first;
      if (child != null) {
        child.frame = source.frame;
        // source.child.currentContext = source.currentContext;
        var statement = child != null
            ? 'child: ${child.generator.generate(child, context)}'
            : '';
        buffer.write(statement);
      }
      buffer.write(')');
      return buffer.toString();
    }
    return '';
  }

  String getPadding(InjectedPadding padding) {
    var buffer = StringBuffer();

    buffer.write('padding: EdgeInsets.only(');

    buffer.write('left: ${padding.left ?? 0},');

    buffer.write('right: ${padding.right ?? 0},');

    buffer.write('top: ${padding.top ?? 0},');

    buffer.write('bottom: ${padding.bottom ?? 0},');

    buffer.write('),');
    return buffer.toString();
  }
}
