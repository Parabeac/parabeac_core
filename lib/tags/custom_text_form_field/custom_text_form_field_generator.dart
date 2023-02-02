import 'package:get_it/get_it.dart';
import 'package:parabeac_core/analytics/amplitude_analytics_service.dart';
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
import 'package:parabeac_core/tags/custom_text_form_field/text_form_field_object.dart';
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
    var hinttext = context.tree.findChild<InheritedText>(
      source,
      hintTextSemantic,
    );

    var prefixIcon = context.tree.findChild<PBIntermediateNode>(
      source,
      prefixIconSemantic,
    );

    var suffixIcon = context.tree.findChild<PBIntermediateNode>(
      source,
      suffixIconSemantic,
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

    var formattedLogicFilename = logicFilename.pascalCase;

    /// Write the concrete TextFormField logic to a separate file.
    context.configuration.generationConfiguration.fileStructureStrategy
        .commandCreated(
      WriteSymbolCommand(
        Uuid().v4(),
        logicFilename,
        customBoilerPlate(
          '$formattedLogicFilename',
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
      // Add tag to analytics
      if (!context.tree.lockData) {
        GetIt.I.get<AmplitudeService>().addToSpecified(
            'CustomTextFormField', 'tag', 'Number of tags generated');
      }
      return '${widgetFilename.pascalCase}(logic: $formattedLogicFilename(context),)';
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
    var currentFields = _buildFields();
    return '''
import 'package:flutter/material.dart';
import 'package:$concreteLogicImport';
import 'package:$abstractLogicImport';
class $className extends StatelessWidget {

  final TextFormFieldLogic logic;

  $className({Key? key, required this.logic,}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return TextFormField(
      style: $hintStyle,
      decoration: InputDecoration(
        hintStyle: $hintStyle,
        prefixIcon: $prefixIcon,
        enabledBorder: $border,
        filled: true, 
        fillColor: $fillColor,
        suffixIcon: ${suffixIcon ?? 'logic.suffixIcon'},
        focusedBorder: logic.focusedBorder,
        hintText: logic.hintText,
        label: logic.label,
      ),
      ${currentFields[0]}
    );
  }

}
''';
  }

  /// Boilerplate for the abstract logic file
  static final String _textFieldLogicBoilerPlate = '''
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Class that serves as a base for all logic classes that are used by the TextField widget.
///
/// The use of this class is that it provides a common interface for all logic classes that are used by the TextField widget.
/// Therefore, any developer-owned TextField widget can extend the specific logic that it needs.
class TextFormFieldLogic {

  TextFormFieldLogic(
    this.context, {
    $_constructorFields
  });
  final BuildContext context;

  $_fields
}

''';

  static String get _constructorFields {
    var buffer = StringBuffer();
    textFormFieldList.forEach((element) {
      var initialValue =
          element.initialValue != null ? ' = ${element.initialValue}' : '';
      buffer.write('this.${element.name}$initialValue,\n');
    });
    return buffer.toString();
  }

  static String get _fields {
    var buffer = StringBuffer();
    textFormFieldList.forEach((element) {
      buffer.write('final ${element.type} ${element.name};\n\n');
    });
    return buffer.toString();
  }

  static List<String> _buildFields() {
    var decorationBuffer = StringBuffer();
    var buffer = StringBuffer();
    textFormFieldList.forEach((element) {
      if (element.isDecoration) {
        decorationBuffer.write('${element.name} : logic.${element.name},\n');
      } else {
        buffer.write('${element.name} : logic.${element.name},\n');
      }
    });
    return [buffer.toString(), decorationBuffer.toString()];
  }
}
