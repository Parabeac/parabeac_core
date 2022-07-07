import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/generation/generators/plugins/pb_plugin_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:recase/recase.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

import '../../controllers/main_info.dart';
import '../../generation/generators/import_generator.dart';
import '../../generation/generators/value_objects/file_structure_strategy/commands/write_symbol_command.dart';
import '../../generation/generators/value_objects/file_structure_strategy/file_ownership_policy.dart';
import '../../generation/generators/visual-widgets/pb_text_gen.dart';
import '../../interpret_and_optimize/entities/inherited_container.dart';
import '../../interpret_and_optimize/entities/inherited_text.dart';
import '../../interpret_and_optimize/entities/layouts/stack.dart';
import '../../interpret_and_optimize/helpers/child_strategy.dart';

class CustomSimpleListView extends PBTag implements PBInjectedIntermediate {
  @override
  String semanticName = '<simple_list_view>';
  CustomSimpleListView(String UUID, Rectangle3D<num> frame, String name)
      : super(UUID, frame, name) {
    generator = CustomSimpleListViewGenerator();
    childrenStrategy = MultipleChildStrategy('children');
  }

  @override
  void extractInformation(PBIntermediateNode incomingNode) {
    // TODO: implement extractInformation
  }

  @override
  PBTag generatePluginNode(Rectangle3D<num> frame,
      PBIntermediateNode originalNode, PBIntermediateTree tree) {
    return CustomSimpleListView(null, frame,
        originalNode.name.replaceAll('<simple_list_view>', '').pascalCase);
  }
}

class CustomSimpleListViewGenerator extends PBGenerator {
  @override
  String generate(PBIntermediateNode source, PBContext context) {
    List<Tuple2> _list = [];
    var textGen, textStyle;

    /// Get text from children by calling the findChild() method
/*    var text =
    _findChild(source, '<itemtext>', context, InheritedContainer);
    var textGen, textStyle;
    if (text != null) {
      var textWidget = context.tree.childrenOf(text).first;
      if (textWidget is InheritedText) {
        textGen = PBTextGen.cleanString(textWidget.text);
        textStyle =
        'TextStyle(color: Color(${textWidget.auxiliaryData.color}))';
      }
    }*/

    for (var i = 1; i <= 4; i++) {
      var text =
          _findChild(source, '<itemtext$i>', context, InheritedContainer);
      if (text != null) {
        var textGen, textStyle;
        var textWidget = context.tree.childrenOf(text).first;
        if (textWidget is InheritedText) {
          textGen = PBTextGen.cleanString(textWidget.text);
          textStyle =
              'TextStyle(color: Color(${textWidget.auxiliaryData.color}))';
          _list.add(Tuple2(textGen, textStyle));
        }
      } else {
        break;
      }
    }

    context.managerData.addImport(FlutterImport(
      'generated_widgets/${source.name.snakeCase}.dart',
      MainInfo().projectName,
    ));
    context.configuration.generationConfiguration.fileStructureStrategy
        .commandCreated(
      WriteSymbolCommand(
        Uuid().v4(),
        source.name.snakeCase,
        _customBoilerPlate(
          source.name,
        ),
        symbolPath: p.join('lib', 'generated_widgets'),
        ownership: FileOwnership.DEV,
      ),
    );
    if (source is CustomSimpleListView) {
      return _listViewBoilerPlate(
          text: textGen,
          hintStyle: textStyle,
          list: _list,
          source: source,
          context: context);
    }
  }

  /// Finds a [PBIntermediateNode] inside `node` of `type`, containing `name`.
  ///
  /// Returns null if not found.
  PBIntermediateNode _findChild(
      PBIntermediateNode node, String name, PBContext context, Type type) {
    print('node.name=${node.name}');
    if (node.name != null &&
        node.name.contains(name) &&
        node.runtimeType == type) {
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

  String _listViewBoilerPlate(
      {String text,
      String hintStyle,
      List<Tuple2> list,
      PBIntermediateNode source,
      PBContext context}) {
    return '''
    ListView(
      children: const 
        ${getListTiles(list, source, context)}
      ,
    )
    ''';
  }

  String _customBoilerPlate(
    String className, {
    String hintText,
    //String border,
    //String prefixIcon,
    //String fillColor,
    //String hintStyle,
  }) {
    return '''
      /// This file holds the methods that are used by the TextField when actions occur within it.
       
      void onSubmitted(String text){
        print(text);
      }
      ''';
  }

  List getListTiles(
      List<Tuple2> list, PBIntermediateNode source, PBContext context) {
    var listTileList = [];
    for (var i = 0; i < list.length; i++) {
      listTileList.add(
          "Padding(padding: EdgeInsets.only(bottom: ${getMarginBetweenListViewItems(source, context).toDouble()}), child: ListTile(title: Text(\'${list[i].item1}\', style: ${list[i].item2}), leading: CircleAvatar(radius: 30.0, backgroundImage: NetworkImage('https://i.imgur.com/BoN9kdC.png'), backgroundColor: Colors.transparent,),),)");
    }
    //listTileList.add("ListTile(title: Text(\'${list[i].item1}\', style: ${list[i].item2}), leading: CircleAvatar(radius: 30.0, backgroundImage: NetworkImage('https://i.imgur.com/BoN9kdC.png'), backgroundColor: Colors.transparent,),)");
    return listTileList;
  }

  num getMarginBetweenListViewItems(
      PBIntermediateNode source, PBContext context) {
    var children = context.tree.childrenOf(source);
    var yDistance = 18.0;
    /*for(var i=0; i<children.length; i++) {
      print('$i================');
      print('name=${children[i].name}');
      print('id=${children[i].id}');
      print('\n');
      if(children[i].name.contains("<listview_item1>")) {
        item1 = children[i];
      } else if(children[i].name.contains("<listview_item2>")) {
        item2 = children[i];
      }
    }*/
    var frame3 = context.tree.findChild(
        source, 'Frame 3<listview_item1>', PBIntermediateStackLayout);
    var frame4 = context.tree.findChild(
        source, 'Frame 4<listview_item2>', PBIntermediateStackLayout);
    var frame7 = context.tree.findChild(
        source, 'Frame 7<listview_item5>', PBIntermediateStackLayout);
    var frame6 = context.tree.findChild(
        source, 'Frame 6<listview_item4>', PBIntermediateStackLayout);
    var frame3_4_spacing;
    var frame6_7_spacing;
    if (frame3 != null && frame4 != null) {
      frame3_4_spacing = (frame3.frame.bottom - frame4.frame.top).abs();
    }

    if (frame6 != null && frame7 != null) {
      frame6_7_spacing = (frame6.frame.bottom - frame7.frame.top).abs();
    }
    return yDistance;
  }
}
