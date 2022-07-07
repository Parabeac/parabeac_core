import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/import_generator.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/plugins/pb_plugin_node.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/write_symbol_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/file_ownership_policy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/auxilary_data_helpers/intermediate_border_info.dart';
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';
import 'package:uuid/uuid.dart';

class CustomCheckBox extends PBTag {
  @override
  String semanticName = '<checkbox>';
  CustomCheckBox(
    String UUID,
    Rectangle3D frame,
    String name,
  ) : super(UUID, frame, name) {
    generator = CustomCheckBoxGenerator();
    childrenStrategy = MultipleChildStrategy('children');
  }

  @override
  void extractInformation(PBIntermediateNode incomingNode) {
    // TODO: implement extractInformation
  }

  @override
  PBTag generatePluginNode(Rectangle3D frame, PBIntermediateNode originalRef,
      PBIntermediateTree tree) {
    return CustomCheckBox(
      // originalRef.UUID,
      null,
      frame,
      originalRef.name.replaceAll('<checkbox>', '').pascalCase,
    );
  }

  @override
  PBIntermediateNode handleIntermediateNode(PBIntermediateNode iNode,
      PBIntermediateNode parent, PBTag tag, PBIntermediateTree tree) {
    if (iNode is PBSharedMasterNode) {
      iNode.generator = CustomCheckBoxGenerator();
    }
    return super.handleIntermediateNode(iNode, parent, tag, tree);
  }
}

class CustomCheckBoxGenerator extends PBGenerator {
  /// Path to file that will contain the logic for the checkbox.
  ///
  /// The path is relative to `lib`.
  static const LOGIC_PATH = 'controller';

  /// Path to the file that will contain the UI for the checkbox.
  ///
  /// The path is relative to `lib`.
  static const UI_PATH = 'widgets/checkbox';

  @override
  String generate(PBIntermediateNode source, PBContext context) {
    /// Get boxDecoration from children by calling the findChild() method
    var boxDecoration =
        _findChild(source, '<boxdecoration>', context, InheritedContainer);

    /// Get boxDecoration from children by calling the findChild() method
    var getCheckedDecoration = _findChild(
        source, '<checkboxcheckedcolor>', context, InheritedContainer);

    /// Variables that will hold generated attributes of TextField.
    /// Holds color of the CheckBox background.
    var fillColor;

    /// Holds color of checked box.
    var fillCheckedColor;

    /// Holds border color, radius, etc.
    var borderInfo;

    /// holds width/height of the frame
    var frameInfo;

    /// Generate [OutlineInputBorder] from [boxDecoration].
    if (boxDecoration != null) {
      borderInfo = boxDecoration.auxiliaryData.borderInfo;
      fillColor = 'Color(${boxDecoration.auxiliaryData.color})';
      frameInfo = boxDecoration.frame;
    }

    if (getCheckedDecoration != null) {
      fillCheckedColor = 'Color(${getCheckedDecoration.auxiliaryData.color})';
    }

    /// Create file containing the logic for this `Checkbox`.
    ///
    /// The file containing logic will be owned by the developer.
    context.configuration.generationConfiguration.fileStructureStrategy
        .commandCreated(
      WriteSymbolCommand(
        Uuid().v4(),
        '${source.name.snakeCase}_logic',
        logicBoilerplate(source.name),
        symbolPath: p.join('lib', LOGIC_PATH),
        ownership: FileOwnership.DEV,
      ),
    );

    /// If source is a [PBSharedMasterNode], we don't need to write
    /// a UI file.
    if (source is PBSharedMasterNode) {
      /// Return the UI code for this `Checkbox`.
      return checkboxBoilerplate(
        fillColor: _fillColor(fillCheckedColor, fillColor),
        borderDecoration: _decoration(borderInfo, fillColor),
        size: _size(frameInfo),
        name: source.name,
      );
    } else if (context.tree.childrenOf(source).first
        is PBSharedInstanceIntermediateNode) {
      return '${source.name.pascalCase}()';
    }

    /// Create a separate UI file for Checkbox so we can inject the logic in the
    /// stateful widget.
    ///
    /// The file containing UI will be owned by parabeac
    ///
    /// TODO: Add a way to inject logic into the original widget without having
    /// to write a separate file.

    context.managerData.addImport(
      FlutterImport(
        '$UI_PATH/${source.name.snakeCase}.g.dart',
        MainInfo().projectName,
      ),
    );
    context.configuration.generationConfiguration.fileStructureStrategy
        .commandCreated(
      WriteSymbolCommand(
        Uuid().v4(),
        source.name.snakeCase,
        checkboxBoilerplate(
          fillColor: _fillColor(fillCheckedColor, fillColor),
          borderDecoration: _decoration(borderInfo, fillColor),
          size: _size(frameInfo),
          name: source.name,
        ),
        symbolPath: p.join('lib', UI_PATH),
        ownership: FileOwnership.PBC,
      ),
    );

    return '${source.name.pascalCase}()';
  }

  /// Returns the boilerplate for the UI of the Checkbox.
  String checkboxBoilerplate({
    String borderDecoration,
    String size,
    String fillColor,
    String name,
  }) {
    var className = name.pascalCase;
    return '''
    import 'package:flutter/material.dart'; 
    import 'package:${MainInfo().projectName}/controller/${name.snakeCase}_logic.dart';

    class $className extends StatefulWidget {
      $className([var constraints]);
      @override
      _${className}State createState() => _${className}State();
    }

    class _${className}State extends State<$className> {
      bool _isChecked = false;

      var logic = ${className}Logic();

      @override
      Widget build(BuildContext context) {
        return Container(
          $size
          $borderDecoration
          child: Checkbox(
            value: logic.getValue(context),
            $fillColor
            onChanged: (bool? value) => logic.onChanged(newValue: value!, context: context, setState: setState,),
          ),
        );
      }
    }


    ''';
  }

  /// Returns the boilerplate for the logic of the Checkbox.
  ///
  /// This logic is intended to go in a separate, dev-owned file.
  String logicBoilerplate(String name) {
    var className = name.pascalCase;
    return '''
import 'package:flutter/material.dart';

class ${className}Logic {

  bool _value = false;

  /// Function that returns the current value of the checkbox.
  /// 
  /// `context` is needed in order to potentially be able to conect 
  /// this [Checkbox] to a State Management System.
  /// 
  /// For example, `context.watch<MyCheckboxBloc>().state`
  bool getValue(BuildContext context) => _value;

  /// Function called when the checkbox is tapped.
  /// 
  /// `context` is needed in order to potentially be able to conect 
  /// this [Checkbox] to a State Management System.
  /// 
  /// For example, `context.read<MyCheckboxBloc>().toggle()`
  void onChanged({required bool newValue, required BuildContext context, Function? setState}) {
    if(setState != null){
      setState(() {
        _value = newValue;
      });
    }
  }
}
    ''';
  }

  /// Finds a [PBIntermediateNode] inside `node` of `type`, containing `name`.
  ///
  /// Returns null if not found.
  PBIntermediateNode _findChild(
      PBIntermediateNode node, String name, PBContext context, Type type) {
    if (node.name.contains(name) && node.runtimeType == type) {
      return node;
    } else {
      for (var child in context.tree.childrenOf(node)) {
        var result = _findChild(child, name, context, type);
        if (result != null) {
          return result;
        }
      }
    }
    return null;
  }

  String _size(Rectangle3D<num> rectangle3d) {
    if (rectangle3d == null) {
      return '';
    }
    return 'width: ${rectangle3d.width}, height: ${rectangle3d.height},';
  }

  /// Takes in [IntermediateBorderInfo] and returns a String that can be used
  /// to decorate the container wrapping the Checkbox.
  String _decoration(IntermediateBorderInfo info, String fillColor) {
    if (info == null) {
      return '';
    }

    ///TODO: Fix this
    return '''
      decoration: BoxDecoration(
        color: $fillColor,
        border: Border.all(
          width: ${info.thickness},
          color: Color(${info.color}),
        ),
        borderRadius: BorderRadius.circular(${info.borderRadius}),
      ),''';
  }

  /// takes in `fillCheckedColor` and `fillColor` and returns a String that can be used
  /// to decorate the checkbox state colors.
  String _fillColor(String fillCheckedColor, String fillColor) {
    var checkedColor = fillCheckedColor ?? 'Colors.blue';
    return '''
      fillColor: MaterialStateProperty.resolveWith(
        (states) {
          if (states.contains(MaterialState.selected)) {
            return $checkedColor;
          } 
          ${fillColor != null ? 'return $fillColor;' : ''}
        },
      ),
    ''';
  }
}
