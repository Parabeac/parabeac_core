import 'dart:convert';
import 'dart:io';

class FlutterPageBuilder {
  String pathToFlutterProject;
  String pathToIntermiateFile;
  String _kPathToLib;

  FlutterPageBuilder({this.pathToFlutterProject, this.pathToIntermiateFile}) {
    _kPathToLib = '${pathToFlutterProject}lib';
  }

  void generatePage() async {
    var intermediate =
        jsonDecode(File(pathToIntermiateFile).readAsStringSync());
    var intermediateGroups = intermediate['pages'];

    // Generate Groups
    for (var i = 0; i < intermediateGroups.length; i++) {
      var pageName =
          intermediateGroups[i]['name'].toLowerCase().replaceAll(' ', '_');

      await Directory('${pathToFlutterProject}lib/screens/${pageName}')
          .create(recursive: true);

      for (var j = 0; j < intermediateGroups[i]['screens'].length; j++) {
        _generateScreen(pageName, intermediateGroups[i]['screens'][j], j);
      }
      for (var j = 0; j < intermediateGroups[i]['shared'].length; j++) {
        _generateItem(
            pageName, intermediateGroups[i]['shared'][j], j, 'shared');
      }
      for (var j = 0; j < intermediateGroups[i]['misc'].length; j++) {
        _generateItem(pageName, intermediateGroups[i]['misc'][j], j, 'misc');
      }
    }
  }

  void _generateScreen(String groupName, Map item, int iteratorValue) {
    var screenName = item['name'] ?? 'some_screen$iteratorValue';

    var output = File(
        '$_kPathToLib/screens/$groupName/${screenName.toString().replaceAll(" ", "_").toLowerCase()}.f.json');
    output.createSync();
    output.writeAsStringSync(jsonEncode(item));
  }

  void _generateItem(
      String groupName, Map item, int iteratorValue, String type) {
    var sharedFileName =
        '${groupName}_${type.toLowerCase()}' ?? 'group_${type.toLowerCase()}';
    var path =
        '$_kPathToLib/screens/$groupName/${sharedFileName.toString().replaceAll(" ", "_").toLowerCase()}.f.json';
    var alreadyExists = FileSystemEntity.isFileSync(path);
    var output = File(path);

    String str;
    if (alreadyExists) {
      str = output.readAsStringSync();
      var json = jsonDecode(str);
      (json['items'] as List).add(jsonEncode(item).toString());
    } else {
      var map = {};
      map['items'] = [];
      map['type'] = type;
      str = jsonEncode(map);
    }
    var json = jsonDecode(str);
    var listCopy = [];
    listCopy.addAll(json['items']);
    listCopy.add(item);
    json['items'] = listCopy;

    output.writeAsStringSync(jsonEncode(json));
  }
}
