import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/import_generator.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/plugins/pb_plugin_node.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/write_symbol_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/file_ownership_policy.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_text_gen.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_text.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/auxilary_data_helpers/intermediate_border_info.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_auxillary_data.dart';
import 'package:uuid/uuid.dart';
import 'package:recase/recase.dart';

class CustomTextFormField extends PBTag {
  @override
  final String semanticName = '<textformfield>';
  CustomTextFormField(
    String UUID,
    Rectangle3D frame,
    String name, {
    IntermediateAuxiliaryData auxiliaryData,
  }) : super(
          UUID,
          frame,
          name,
          auxiliaryData: auxiliaryData,
        ) {
    generator = CustomTextFormFieldGenerator();
    childrenStrategy = MultipleChildStrategy('children');
  }

  @override
  PBIntermediateNode handleIntermediateNode(PBIntermediateNode iNode,
      PBIntermediateNode parent, PBTag tag, PBIntermediateTree tree) {
    /// Need to remove auxiliary data from component so it's not duplicated
    if (iNode is PBSharedMasterNode) {
      iNode.auxiliaryData = IntermediateAuxiliaryData();
    }
    return super.handleIntermediateNode(iNode, parent, tag, tree);
  }

  @override
  void extractInformation(PBIntermediateNode incomingNode) {
    // TODO: implement extractInformation
  }

  @override
  PBTag generatePluginNode(Rectangle3D frame, PBIntermediateNode originalRef,
      PBIntermediateTree tree) {
    return CustomTextFormField(
      null,
      frame.copyWith(),
      originalRef.name.replaceAll(semanticName, '').pascalCase,
      auxiliaryData: originalRef.auxiliaryData.copyWith(),
    );
  }
}

class CustomTextFormFieldGenerator extends PBGenerator {
  /// Subsemantics for the text field.
  final String hintTextSemantic = '<hinttext>';
  final String prefixIconSemantic = '<prefixIcon>';
  final String suffixIconSemantic = '<suffixIcon>';

  @override
  String generate(PBIntermediateNode source, PBContext context) {
    /// Variables that will hold generated attributes of TextField.
    String hinttextGen;
    String hintStyle;
    String prefixIconGen;
    String fillColor;
    String outlineInputBorder;
    String suffixIconGen;

    /// Get subsemantic nodes
    var hinttext = context.tree.firstWhere(
      (element) =>
          element.name.contains(hintTextSemantic) && element is InheritedText,
      orElse: () => null,
    );

    var prefixicon = context.tree.firstWhere(
      (element) => element.name.contains(prefixIconSemantic),
      orElse: () => null,
    );

    var suffixIcon = context.tree.firstWhere(
      (element) => element.name.contains(suffixIconSemantic),
      orElse: () => null,
    );

    /// Generate [OutlineInputBorder] from [boxDecoration].
    if (source.auxiliaryData != null) {
      fillColor = 'Color(${source.auxiliaryData.color ?? '0xFFFFFFFF'})';
      outlineInputBorder =
          _generateOutlineInputBorder(source.auxiliaryData.borderInfo);
    }

    /// Get [hinttextGen] from [hinttext].
    if (hinttext != null && hinttext is InheritedText) {
      hinttextGen = PBTextGen.cleanString(hinttext.text);
      hintStyle = 'TextStyle(color: Color(${hinttext.auxiliaryData.color}))';
    }

    /// Generate [prefixIconGen] from [prefixicon].
    if (prefixicon != null) {
      prefixIconGen = prefixicon.generator.generate(
            prefixicon,
            context.copyWith(sizingContext: SizingValueContext.ScaleValue),
          ) ??
          '';
    }

    /// Generate [suffixIconGen] from [suffixIcon].
    if (suffixIcon != null) {
      suffixIconGen = suffixIcon.generator.generate(
            suffixIcon,
            context.copyWith(sizingContext: SizingValueContext.ScaleValue),
          ) ??
          '';
    }

    var logicFilename = '${source.name.snakeCase}_logic';
    var widgetFilename = '${source.name.snakeCase}_widget';

    /// Add imports to files to be created.
    context.managerData.addImport(FlutterImport(
      'generated_widgets/$logicFilename.dart',
      MainInfo().projectName,
    ));

    context.managerData.addImport(FlutterImport(
      'my_path/$widgetFilename.g.dart',
      MainInfo().projectName,
    ));

    /// Write the TextFormField logic to a separate file.
    context.configuration.generationConfiguration.fileStructureStrategy
        .commandCreated(
      WriteSymbolCommand(
        Uuid().v4(),
        logicFilename,
        customBoilerPlate('${logicFilename.pascalCase}'),
        relativePath: 'generated_widgets',
        symbolPath: 'lib',
        ownership: FileOwnership.DEV,
      ),
    );

    /// Write the TextFormField UI to a separate file.
    context.configuration.generationConfiguration.fileStructureStrategy
        .commandCreated(
      WriteSymbolCommand(
        Uuid().v4(),
        widgetFilename,
        textFieldBoilerPlate(
          '${widgetFilename.pascalCase}',
          hintText: hinttextGen,
          border: outlineInputBorder,
          prefixIcon: prefixIconGen,
          suffixIcon: suffixIconGen,
          fillColor: fillColor,
          hintStyle: hintStyle,
        ),
        relativePath: 'my_path',
        symbolPath: 'lib',
        ownership: FileOwnership.PBC,
      ),
    );
    if (source is CustomTextFormField) {
      return '${widgetFilename.pascalCase}()';
    }
    return '';
  }

  /// Extracts information from [boxDecoration] and generates [OutlineInputBorder].
  String _generateOutlineInputBorder(IntermediateBorderInfo borderInfo) {
    if (borderInfo != null) {
      return '''
        OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(${borderInfo.color ?? '0xFFFFFFFF'}),
            width: ${borderInfo.thickness ?? 1},
          ),
          borderRadius: BorderRadius.circular(${borderInfo.borderRadius ?? 0}),
        )
      ''';
    }
    return '';
  }

  String customBoilerPlate(String className) {
    return '''

class $className {
}
      ''';
  }

  String textFieldBoilerPlate(
    String className, {
    String hintText,
    String border,
    String prefixIcon,
    String suffixIcon,
    String fillColor,
    String hintStyle,
  }) {
    return '''
import 'package:flutter/material.dart';
class $className extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return TextField(
      style: $hintStyle,
      decoration: InputDecoration(
        ${hintText != null ? 'hintText: \'$hintText\',' : ''}
        hintStyle: $hintStyle,
        prefixIcon: $prefixIcon,
        focusedBorder: $border,
        enabledBorder: $border,
        filled: true, 
        fillColor: $fillColor,
        suffixIcon: $suffixIcon,
      ),
      onSubmitted: (value) {},
    );
  }

}
''';
  }
}
