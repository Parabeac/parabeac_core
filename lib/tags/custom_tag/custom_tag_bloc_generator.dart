import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/import_generator.dart';
import 'package:parabeac_core/generation/generators/util/pb_input_formatter.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/write_symbol_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/file_ownership_policy.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/tags/custom_tag/custom_tag.dart';
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
    var cleanName = PBInputFormatter.formatLabel(source.name);

    // TODO: correct import
    context.managerData.addImport(FlutterImport(
      '${CustomTagGenerator.DIRECTORY_GEN}/$cleanName.dart',
      MainInfo().projectName,
    ));

    var fss =
        context.configuration.generationConfiguration.fileStructureStrategy;

    /// Generate custom file
    fss.commandCreated(
      WriteSymbolCommand(
        Uuid().v4(),
        cleanName,
        customBoilerPlate(titleName),
        relativePath: p.join('${CustomTagGenerator.DIRECTORY_GEN}', cleanName),
        symbolPath: 'lib',
        ownership: FileOwnership.DEV,
      ),
    );

    /// Generate State

    /// Generate Cubit

    if (source is CustomTag) {
      return '''
        $titleName(
          child: ${children[0].generator.generate(children[0], context)}
        )
      ''';
    }
    return '';
  }

  @override
  String customBoilerPlate(String className) {
    return '''
      import 'package:flutter/material.dart';
      import 'package:flutter_bloc/flutter_bloc.dart';

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
            create: (_) => ${className}Cubit(),
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
}
