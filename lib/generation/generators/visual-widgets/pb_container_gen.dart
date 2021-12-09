import 'package:parabeac_core/generation/generators/attribute-helper/pb_box_decoration_gen_helper.dart';
import 'package:parabeac_core/generation/generators/attribute-helper/pb_color_gen_helper.dart';
import 'package:parabeac_core/generation/generators/attribute-helper/pb_size_helper.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
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
    if (source is InjectedContainer || source is InheritedContainer) {
      var sourceChildren = context.tree.childrenOf(source);
      var buffer = StringBuffer();
      buffer.write('Container(');

      //TODO(ivanV): please clean my if statement :(
      if (source is InjectedContainer) {
        if (source.padding != null) {
          buffer.write(getPadding(source.padding));
        }

        if (source.pointValueHeight) {
          buffer.write('height: ${source.frame.height},');
        }
        if (source.pointValueWidth) {
          buffer.write('width: ${source.frame.width},');
        }
        if (!source.pointValueHeight && !source.pointValueWidth) {
          buffer.write(PBSizeHelper().generate(source, context));
        }
      } else {
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

    buffer.write('EdgeInsets.only(');

    if (padding.left != null) {
      buffer.write('left: ${padding.left},');
    }
    if (padding.right != null) {
      buffer.write('right: ${padding.right},');
    }
    if (padding.top != null) {
      buffer.write('top: ${padding.top},');
    }
    if (padding.bottom != null) {
      buffer.write('bottom: ${padding.bottom},');
    }
    buffer.write('),');
    return buffer.toString();
  }
}
