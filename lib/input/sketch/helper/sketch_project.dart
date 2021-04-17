import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/util/pb_input_formatter.dart';
import 'package:parabeac_core/input/helper/design_project.dart';
import 'package:parabeac_core/input/sketch/entities/documents/document.dart';
import 'package:parabeac_core/input/sketch/entities/layers/page.dart';
import 'package:parabeac_core/input/sketch/entities/objects/foreign_symbol.dart';
import 'package:parabeac_core/input/sketch/entities/style/shared_style.dart';
import 'package:parabeac_core/input/sketch/helper/sketch_page.dart';
import 'package:parabeac_core/input/sketch/helper/sketch_screen.dart';
import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:parabeac_core/input/sketch/services/input_design.dart';
import 'package:quick_log/quick_log.dart';
import 'package:recase/recase.dart';

class SketchProject extends DesignProject {
  @override
  var log = Logger('SketchNodeTree');
  SketchPage rootScreen;

  @override
  String projectName;
  @override
  bool debug = false;

  final InputDesignService _ids;
  Archive _originalArchive;
  final Map _pagesAndArtboards;
  SketchProject(this._ids, this._pagesAndArtboards, this.projectName) {
    id = _ids.documentFile['do_objectID'];
    _originalArchive = _ids.archive;
    miscPages.add(_setThirdPartySymbols());
    sharedStyles = _setSharedStyles();
    pages.addAll(_setConventionalPages(_pagesAndArtboards));
    if (debug) {
      print(pages);
    }
  }

  List<SharedStyle> _setSharedStyles() {
    try {
      List<SharedStyle> sharedStyles = [];
      var jsonData = _ids.documentFile;
      var doc = Document.fromJson(jsonData);
      if (doc.layerStyles != null) {
        var LayerStyles = doc.layerStyles['objects'] ?? [];
        for (var sharedStyle in LayerStyles) {
          var layerStyle = SharedStyle.fromJson(sharedStyle);
          layerStyle.name = PBInputFormatter.formatVariable(layerStyle.name);
          sharedStyles.add(layerStyle);
        }
      }

      if (doc.layerTextStyles != null) {
        var LayerTextStyles = doc.layerTextStyles['objects'] ?? [];

        for (var sharedStyle in LayerTextStyles) {
          var layerTextStyle = SharedStyle.fromJson(sharedStyle);
          layerTextStyle.name =
              PBInputFormatter.formatVariable(layerTextStyle.name.camelCase);
          sharedStyles.add(layerTextStyle);
        }
      }

      return sharedStyles;
    } catch (e, stackTrace) {
      MainInfo().sentry.captureException(
            exception: e,
            stackTrace: stackTrace,
          );
      log.error(e.toString());
      return null;
    }
  }

  SketchPage _setThirdPartySymbols() {
    try {
      var jsonData = _ids.documentFile;
      var doc = Document.fromJson(jsonData);
      var foreignLayers = doc.foreignSymbols ?? <ForeignSymbol>[];
      var pg = SketchPage('third_party_widgets', jsonData['do_objectID']);
      for (var layer in foreignLayers) {
        pg.addScreen(SketchScreen(
          layer.originalMaster,
          layer.UUID,
          '',
          layer.originalMaster.type,
        ));
      }
      return pg;
    } catch (e, stackTrace) {
      MainInfo().sentry.captureException(
            exception: e,
            stackTrace: stackTrace,
          );
      log.error(e.toString());
      return null;
    }
  }

  List<SketchPage> _setConventionalPages(Map pagesAndArtboards) {
    var sketchPages = <SketchPage>[];
    for (var entry in pagesAndArtboards.entries) {
      var pageContent =
          _originalArchive.findFile('pages/${entry.key}.json').content;
      var jsonData = json.decode(utf8.decode(pageContent));

      var pbdlPage = getPbdlPage(jsonData['do_objectID']);
      if (pbdlPage != null && !(pbdlPage['convert'] ?? true)) {
        continue;
      }

      var pg = SketchPage(
          jsonData['name'], jsonData['do_objectID']); // Sketch Node Holder
      var node = Page.fromJson(jsonData); // Actual Sketch Node

      // Turn layers into PBNodes
      for (var layer in node.children) {
        var pbdlScreen = getPbdlScreen(pbdlPage, layer.UUID);
        if (pbdlScreen != null && !(pbdlScreen['convert'] ?? true)) {
          continue;
        }
        pg.addScreen(SketchScreen(
          layer,
          layer.UUID,
          layer.name,
          layer.type,
        ));
      }
      sketchPages.add(pg);
    }
    return sketchPages;
  }
}
