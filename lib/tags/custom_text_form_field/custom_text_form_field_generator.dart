import 'package:get_it/get_it.dart';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/import_generator.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/write_symbol_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/file_ownership_policy.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/path_services/path_service.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_text_gen.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_text_style_gen_mixin.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_text.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/auxilary_data_helpers/intermediate_border_info.dart';
import 'package:parabeac_core/tags/custom_text_form_field/custom_text_form_field.dart';
import 'package:recase/recase.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

class CustomTextFormFieldGenerator extends PBGenerator with PBTextStyleGen {
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
    var hinttext = context.tree.findChild(
      source,
      hintTextSemantic,
      InheritedText,
    );

    var prefixIcon = context.tree.findChild(
      source,
      prefixIconSemantic,
      PBIntermediateNode,
    );

    var suffixIcon = context.tree.findChild(
      source,
      suffixIconSemantic,
      PBIntermediateNode,
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
      hintStyle = getStyle(hinttext, context);
    }

    /// Generate [prefixIconGen] from [prefixIcon].
    if (prefixIcon != null) {
      prefixIconGen = prefixIcon.generator.generate(
            prefixIcon,
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

    final pathService = GetIt.I<PathService>();
    final projectName = MainInfo().projectName;

    final logicFilename = '${source.name.snakeCase}_logic';
    final widgetFilename = '${source.name.snakeCase}_widget';
    const abstractLogicFilename = 'text_form_field_logic';

    final logicFilePath = p.join(
      WriteSymbolCommand.DEFAULT_SYMBOL_PATH,
      context.tree.name,
      pathService.customRelativePath,
    );
    final widgetFilePath = p.join(
      WriteSymbolCommand.DEFAULT_SYMBOL_PATH,
      context.tree.name,
    );
    final abstractLogicImport = p
            .join(
              projectName,
              WriteSymbolCommand.DEFAULT_SYMBOL_PATH,
              abstractLogicFilename,
            )
            .replaceAll('lib/', '') +
        '.g.dart';
    final concreteLogicImport = p.join(logicFilePath, '$logicFilename.dart');

    /// Add imports to files to be created.
    context.managerData.addImport(FlutterImport(
      concreteLogicImport,
      projectName,
    ));

    context.managerData.addImport(FlutterImport(
      p.join(widgetFilePath, '$widgetFilename.g.dart'),
      projectName,
    ));

    /// Write the abstract TextFormField logic file.
    context.configuration.generationConfiguration.fileStructureStrategy
        .commandCreated(
      WriteSymbolCommand(
        Uuid().v4(),
        abstractLogicFilename,
        _textFieldLogicBoilerPlate,
        ownership: FileOwnership.PBC,
      ),
    );

    /// Write the concrete TextFormField logic to a separate file.
    context.configuration.generationConfiguration.fileStructureStrategy
        .commandCreated(
      WriteSymbolCommand(
        Uuid().v4(),
        logicFilename,
        customBoilerPlate(
          '${logicFilename.pascalCase}',
          abstractLogicImport,
          hinttextGen,
        ),
        symbolPath: logicFilePath,
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
          abstractLogicImport,
          p.join(projectName, concreteLogicImport).replaceAll('lib/', ''),
          logicFilename,
          border: outlineInputBorder,
          prefixIcon: prefixIconGen,
          suffixIcon: suffixIconGen,
          fillColor: fillColor,
          hintStyle: hintStyle,
        ),
        symbolPath: widgetFilePath,
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
    var borderside = '';
    var borderRadius = '';

    borderside =
        'borderSide: BorderSide(color: Color(${borderInfo?.border?.color ?? '0x00ffffff'},), width: ${borderInfo?.thickness ?? 1},),';

    borderRadius =
        'borderRadius: BorderRadius.circular(${borderInfo.borderRadius ?? 1}),';

    return '''
        OutlineInputBorder(
          $borderside
          $borderRadius
        )
      ''';
  }

  /// The logic for the concrete TextFormField.
  String customBoilerPlate(
    String className,
    String logicImport,
    String hintText,
  ) {
    return '''
import 'package:flutter/material.dart';
import 'package:$logicImport';
class $className extends TextFormFieldLogic {
  $className(BuildContext context): super(context);

  /// TODO: Override any logic method here. See example below
  /// See [TextFormFieldLogic] for overridable methods.
  @override
  ValueChanged<String>? get onChanged => (value) {
    //print('Value changed to \$value');
  };

  @override
  String get hintText => '$hintText';
}
      ''';
  }

  /// Boilerplate for the UI of the TextFormField widget that will be generated
  /// when a designer labels a TextFormField node.
  ///
  /// The [className] is the name of the class that will be generated.
  /// The [abstractLogicImport] is the import to the abstract logic class that will be generated. This holds the overridable logic methods.
  /// The [logicImport] is the import to the concrete logic class that will be generated. This contains the actual logic to the specific widget.
  /// The [logicClassName] is the name of the concrete logic class.
  String textFieldBoilerPlate(
    String className,
    String abstractLogicImport,
    String concreteLogicImport,
    String logicClassName, {
    String border,
    String prefixIcon,
    String suffixIcon,
    String fillColor,
    String hintStyle,
  }) {
    return '''
import 'package:flutter/material.dart';
import 'package:$concreteLogicImport';
import 'package:$abstractLogicImport';
class $className extends StatelessWidget {

  late final TextFormFieldLogic _logic;

  $className({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    _logic = ${logicClassName.pascalCase}(context);
    return TextFormField(
      style: $hintStyle,
      decoration: InputDecoration(
        hintText: _logic.hintText,
        hintStyle: $hintStyle,
        prefixIcon: $prefixIcon,
        focusedBorder: $border,
        enabledBorder: $border,
        filled: true, 
        fillColor: $fillColor,
        suffixIcon: $suffixIcon,
      ),
      controller: _logic.controller,
      initialValue: _logic.initialValue,
      keyboardType: _logic.keyboardType,
      textCapitalization: _logic.textCapitalization,
      autofocus: _logic.autofocus,
      readOnly: _logic.readOnly,
      obscureText: _logic.obscureText,
      maxLengthEnforcement: _logic.maxLengthEnforcement,
      minLines: _logic.minLines,
      maxLines: _logic.maxLines,
      expands: _logic.expands,
      maxLength: _logic.maxLength,
      onChanged: _logic.onChanged,
      onTap: _logic.onTap,
      onEditingComplete: _logic.onEditingComplete,
      onFieldSubmitted: _logic.onFieldSubmitted,
      onSaved: _logic.onSaved,
      validator: _logic.validator,
      inputFormatters: _logic.inputFormatters,
      enabled: _logic.enabled,
      scrollPhysics: _logic.scrollPhysics,
      autovalidateMode: _logic.autovalidateMode,
      scrollController: _logic.scrollController,
    );
  }

}
''';
  }

  /// Boilerplate for the abstract logic file
  static const String _textFieldLogicBoilerPlate = '''
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Class that serves as a base for all logic classes that are used by the TextField widget.
///
/// The use of this class is that it provides a common interface for all logic classes that are used by the TextField widget.
/// Therefore, any developer-owned TextField widget can extend the specific logic that it needs.
abstract class TextFormFieldLogic {

  TextFormFieldLogic(
    this.context, {
    this.controller,
    this.initialValue,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.autofocus = false,
    this.readOnly = false,
    this.obscureText = false,
    this.maxLengthEnforcement,
    this.minLines,
    this.maxLines = 1,
    this.expands = false,
    this.maxLength,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onSaved,
    this.validator,
    this.inputFormatters,
    this.enabled,
    this.scrollPhysics,
    this.autovalidateMode,
    this.scrollController,
    this.hintText = '',
  });

  final BuildContext context;

  final TextEditingController? controller;

  final String? initialValue;

  final TextInputType? keyboardType;

  final TextCapitalization textCapitalization;

  final bool autofocus;

  final bool readOnly;

  final bool obscureText;

  final MaxLengthEnforcement? maxLengthEnforcement;

  final int? minLines;

  final int? maxLines;

  final bool expands;

  final int? maxLength;

  final ValueChanged<String>? onChanged;

  final GestureTapCallback? onTap;

  final VoidCallback? onEditingComplete;

  final ValueChanged<String>? onFieldSubmitted;

  final FormFieldSetter<String>? onSaved;

  final FormFieldValidator<String>? validator;

  final List<TextInputFormatter>? inputFormatters;

  final bool? enabled;

  final ScrollPhysics? scrollPhysics;

  final AutovalidateMode? autovalidateMode;

  final ScrollController? scrollController;

  final String hintText;
}

''';
}
