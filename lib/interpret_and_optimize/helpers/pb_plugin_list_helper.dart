import 'package:parabeac_core/eggs/custom_egg.dart';
import 'package:parabeac_core/eggs/injected_app_bar.dart';
import 'package:parabeac_core/eggs/injected_tab.dart';
import 'package:parabeac_core/eggs/injected_tab_bar.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/generation/generators/plugins/pb_plugin_node.dart';
import 'dart:math';
import 'package:uuid/uuid.dart';

/// Helping understand indirect and direct semantics that should remove a node from a tree.
class PBPluginListHelper {
  static final PBPluginListHelper _instance = PBPluginListHelper._internal();
  void initPlugins(PBContext context) {
    allowListNames = {
      '<tabbar>': InjectedTabBar(Point(0, 0), Point(0, 0), Uuid().v4(), '',
          currentContext: context),
      '<navbar>': InjectedAppbar(Point(0, 0), Point(0, 0), Uuid().v4(), '',
          currentContext: context),
      '<tab>': Tab(Point(0, 0), Point(0, 0), '',
          currentContext: context, UUID: Uuid().v4()),
      '<custom>': CustomEgg(Point(0, 0), Point(0, 0), ''),
    };
  }

  factory PBPluginListHelper() => _instance;

  PBPluginListHelper._internal() {
    allowListNames = {
      '<tabbar>': InjectedTabBar(
        Point(0, 0),
        Point(0, 0),
        Uuid().v4(),
        '',
      ),
      '<navbar>': InjectedAppbar(
        Point(0, 0),
        Point(0, 0),
        Uuid().v4(),
        '',
      ),
      '<tab>': Tab(Point(0, 0), Point(0, 0), '', UUID: Uuid().v4()),
      '<custom>': CustomEgg(Point(0, 0), Point(0, 0), ''),
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
  PBEgg returnAllowListNodeIfExists(PBIntermediateNode node) {
    if (node != null) {
      for (var key in allowListNames.keys) {
        if (node.name?.contains(key) ?? false) {
          return allowListNames[key].generatePluginNode(
              node.topLeftCorner, node.bottomRightCorner, node);
        }
      }
    }

    return null;
  }
}
