import 'dart:io';

import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/flutter_project_builder/post_gen_tasks/post_gen_task.dart';
import 'package:yaml_modify/yaml_modify.dart';

class AppendToYamlPostGenTask implements PostGenTask {
  // List of assets to be append to the yaml
  static List<String> assets = [];

  // TODO: WIP for when we add dependencies on the future
  Map dependeciens = {};

  @override
  void execute() {
    var yamlAbsPath = MainInfo().genProjectPath + '/pubspec.yaml';
    var yamlStr = File(yamlAbsPath).readAsStringSync();
    var modifiableyaml = getModifiableNode(loadYaml(yamlStr)) as Map;

    if (modifiableyaml.containsKey('flutter') && assets.isNotEmpty) {
      /// Add only elements that are not already in the yaml
      if (modifiableyaml['flutter'].containsKey('assets') &&
          modifiableyaml['flutter']['assets'] != null) {
        var existingAssets = (modifiableyaml['flutter']['assets'] as List);
        assets.forEach((asset) {
          if (!existingAssets.any((e) => e.endsWith('/$asset'))) {
            existingAssets
                .add('packages/${MainInfo().projectName}/assets/images/$asset');
          }
        });
      }

      /// Add all elements to the yaml
      else {
        modifiableyaml['flutter']['assets'] = assets
            .map((e) => 'packages/${MainInfo().projectName}/assets/images/$e')
            .toList();
      }
    }

    /// Write the new yaml file
    File(yamlAbsPath).writeAsStringSync(toYamlString(modifiableyaml));
  }

  static void addAsset(String name) {
    assets.add(name);
  }
}
