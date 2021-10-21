import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/import_generator.dart';
import 'package:parabeac_core/generation/generators/util/pb_input_formatter.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/write_symbol_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/file_ownership_policy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/tags/custom_tag/custom_tag.dart';
import 'package:recase/recase.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

/// Class that generates BLoC boilerplate when generating a custom tag.
class CustomTagBlocGenerator extends CustomTagGenerator {
  @override
  String generate(PBIntermediateNode source, PBContext context) {
    var children = context.tree.childrenOf(source);
    var titleName = PBInputFormatter.formatLabel(
      source.name,
      isTitle: true,
      destroySpecialSym: true,
    );
    var cleanName = PBInputFormatter.formatLabel(source.name.snakeCase);
    var packageName = MainInfo().projectName;

    var blocRelativePath = p.join('bloc', '$cleanName');

    // TODO: correct import
    context.managerData.addImport(FlutterImport(
      '${CustomTagGenerator.DIRECTORY_GEN}/$cleanName.dart',
      packageName,
    ));

    var fss =
        context.configuration.generationConfiguration.fileStructureStrategy;

    /// Generate State
    var stateName = '${cleanName}_state';
    fss.commandCreated(
      WriteSymbolCommand(
        Uuid().v4(),
        stateName,
        _generateStateBoilerplate(titleName),
        relativePath: blocRelativePath,
        symbolPath: 'lib',
        ownership: FileOwnership.DEV,
      ),
    );
    var stateImport = FlutterImport.importFormat(
      p.join(packageName, blocRelativePath, '$stateName.dart'),
      isPackage: true,
    );

    /// Generate Cubit
    var cubitName = '${cleanName}_cubit';
    fss.commandCreated(
      WriteSymbolCommand(
        Uuid().v4(),
        cubitName,
        _generateCubitBoilerplate(titleName, stateImport),
        relativePath: blocRelativePath,
        symbolPath: 'lib',
        ownership: FileOwnership.DEV,
      ),
    );
    var cubitImport = FlutterImport.importFormat(
      p.join(packageName, blocRelativePath, '$cubitName.dart'),
      isPackage: true,
    );

    /// Generate custom file
    fss.commandCreated(
      WriteSymbolCommand(
        Uuid().v4(),
        cleanName,
        _customBoilerPlate(titleName, cubitImport, stateImport),
        relativePath: CustomTagGenerator.DIRECTORY_GEN,
        symbolPath: 'lib',
        ownership: FileOwnership.DEV,
      ),
    );

    if (source is CustomTag) {
      return '''
        $titleName(
          child: ${children[0].generator.generate(children[0], context)}
        )
      ''';
    }
    return '';
  }

  String _customBoilerPlate(
      String className, String cubitImport, String stateImport) {
    return '''
      import 'package:flutter/material.dart';
      import 'package:flutter_bloc/flutter_bloc.dart';
      $cubitImport
      $stateImport

      class $className extends StatefulWidget{
        final Widget child;
        $className({Key key, this.child}) : super (key: key);

        @override
        _${className}State createState() => _${className}State();
      }

      class _${className}State extends State<$className> {
        @override
        Widget build(BuildContext context){
          return BlocProvider(
            create: (_) => ${className}Cubit(${className}Initial()),
            child: BlocBuilder<${className}Cubit, ${className}State>(
              builder: (context, state) {
                /// TODO: @developer implement bloc and map the states to widgets as desired.
                /// For example, in a counter app you may have something like
                /// 
                /// if(state is CounterInProgress){
                ///   return Text('\${state.value}');
                /// } else {
                ///   return Text('0');
                /// }
                return widget.child;
              }
            ),
          );
        }
      }
      ''';
  }

  String _generateStateBoilerplate(String className) {
    return '''
      abstract class ${className}State {}


      /// TODO: @developer Add states that extend the abstract state above. 
      /// For example, if you are coding a counter, you may want to add something like:
      /// 
      /// class CounterInProgress extends CounterState{
      ///   CounterInProgress(int value): super(value);
      /// }

      class ${className}Initial extends ${className}State {}

    ''';
  }

  String _generateCubitBoilerplate(String className, String stateImport) {
    return '''
      import 'package:flutter_bloc/flutter_bloc.dart';
      $stateImport

      class ${className}Cubit extends Cubit<${className}State> {
        ${className}Cubit(${className}State initialState) : super(initialState);

        /// TODO: @developer add functions here that emit a different state.
        ///
        /// For example, if you're coding a counter, you may want to have a function that 
        /// when called, does the following:
        /// 
        /// void increment() => emit(CounterActive(state.value + 1));
      }
    ''';
  }
}
