import 'package:parabeac_core/eggs/custom_egg.dart';
import 'package:parabeac_core/eggs/injected_app_bar.dart';
import 'package:parabeac_core/eggs/injected_tab.dart';
import 'package:parabeac_core/eggs/injected_tab_bar.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/generation/generators/plugins/pb_plugin_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'dart:math';
import 'package:uuid/uuid.dart';

/// Helping understand indirect and direct semantics that should remove a node from a tree.
class PBPluginListHelper {
  static final PBPluginListHelper _instance = PBPluginListHelper._internal();
  void initPlugins(PBContext context) {
    allowListNames = {
      '<tabbar>': InjectedTabBar(null, null, ''),
      '<navbar>': InjectedAppbar(null, null, ''),
      '<tab>': Tab(
        null,
        null,
        '',
      ),
      '<custom>': CustomEgg(null, null, ''),
    };
  }

  factory PBPluginListHelper() => _instance;

  PBPluginListHelper._internal() {
    allowListNames = {
      '<tabbar>': InjectedTabBar(
        null,
        null,
        '',
      ),
      '<navbar>': InjectedAppbar(
        null,
        null,
        '',
      ),
      '<tab>': Tab(
        null,
        null,
        '',
      ),
      '<custom>': CustomEgg(null, null, ''),
    };
  }

  Map<String, PBEgg> allowListNames;

  /// List of static plugin names used for Amplitude
  static List<String> names = [
    '<background>',
    '<navbar>',
    '<tabbar>',
    '<tab>',
    '<custom>',
  ];

  List<String> baseNames = [
    '<background>',
    '<navbar>',
    '<tabbar>',
    '<tab>',
    '<custom>',
  ];

  /// Adds `node` to the list of plugin nodes if the semantic
  ///  name does not exist
  void addNode(PBEgg node) {
    if (!allowListNames.containsKey(node.semanticName)) {
      allowListNames[node.semanticName] = node;
    }
  }

  /// Remove `node` from list if not part of internal plugin nodes
  /// and if the node is present in the list.
  void removeNode(PBEgg node) {
    if (!baseNames.contains(node.semanticName)) {
      allowListNames.remove(node.semanticName);
    }
  }

  /// Iterates through Plugin List and checks for a match of `node.name`.
  /// Returns the PluginNode associated if it exists.
  PBEgg returnAllowListNodeIfExists(
      PBIntermediateNode node, PBIntermediateTree tree) {
    if (node != null) {
      for (var key in allowListNames.keys) {
        if (node.name?.contains(key) ?? false) {
          return allowListNames[key].generatePluginNode(node.frame, node, tree);
        }
      }
    }

    return null;
  }
}
