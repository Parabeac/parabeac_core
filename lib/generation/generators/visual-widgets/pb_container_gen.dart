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

      /// Add clip behavior in case children needs to be clipped
      /// TODO: Extend to different kinds of clip
      if (source.auxiliaryData.clipsContent ?? false) {
        buffer.write('clipBehavior: Clip.hardEdge,');
      }

      /// Write container padding
      if (source.padding != null) {
        buffer.write(getPadding(source.padding));
      }

      //TODO(ivanV): please clean my if statement :(
      if (source is InjectedContainer) {
        if (source.pointValueHeight &&
            source.frame.height > 0 &&
            source.showHeight) {
          buffer.write('height: ${source.frame.height},');
        } else if (!source.pointValueHeight) {
          buffer.write(
              PBSizeHelper().getSize(source, context, DIMENTIONS.Height));
        }

        if (source.pointValueWidth &&
            source.frame.width > 0 &&
            source.showWidth) {
          buffer.write('width: ${source.frame.width},');
        } else if (!source.pointValueWidth) {
          buffer
              .write(PBSizeHelper().getSize(source, context, DIMENTIONS.Width));
        }
      }

      /// If source is [InheritedContainer] get both width and heigt
      else if (source is InheritedContainer) {
        buffer.write(PBSizeHelper().generate(source, context));
      }

      /// If border info exists, use box decoration for auxiliary data
      if (source.auxiliaryData.borderInfo != null) {
        buffer.write(PBBoxDecorationHelper().generate(source, context));
      }

      /// Else assing the color through the container
      else {
        buffer.write(PBColorGenHelper().generate(source, context));
      }

      /// Check if container has a child
      var child = sourceChildren.isEmpty ? null : sourceChildren.first;
      if (child != null) {
        child.frame = source.frame;
        var statement = 'child: ${child.generator.generate(child, context)}';

        buffer.write(statement);
      }
      buffer.write(')');
      return buffer.toString();
    }
    return '';
  }

  String getPadding(InjectedPadding padding) {
    /// If there are no paddings to write, do not write any padding
    if ((padding.left == null) &&
        (padding.right == null) &&
        (padding.top == null) &&
        (padding.bottom == null)) {
      return '';
    }
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
