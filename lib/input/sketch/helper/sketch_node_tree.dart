import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/input/sketch/entities/documents/document.dart';
import 'package:parabeac_core/input/sketch/entities/layers/page.dart';
import 'package:parabeac_core/input/sketch/entities/objects/foreign_symbol.dart';
import 'package:parabeac_core/input/sketch/helper/sketch_page.dart';
import 'package:parabeac_core/input/sketch/helper/sketch_page_item.dart';
import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:quick_log/quick_log.dart';

class SketchNodeTree {
  var log = Logger('SketchNodeTree');
  List<SketchPage> pages = [];
  List<SketchPage> miscPages = [];
  SketchPage rootScreen;
  String projectName;
  bool debug = false;

  final Archive _originalArchive;
  final Map _pagesAndArtboards;
  SketchNodeTree(
      this._originalArchive, this._pagesAndArtboards, this.projectName) {
    miscPages.add(_setThirdPartySymbols());
    pages.addAll(_setConventionalPages(_pagesAndArtboards));
    if (debug) {
      print(pages);
    }
  }

  SketchPage _setThirdPartySymbols() {
    try {
      var doc_page = _originalArchive.findFile('document.json').content;
      assert(doc_page != null, "Document page from Sketch doesn't exist.");
      var jsonData = json.decode(utf8.decode(doc_page));
      var doc = Document.fromJson(jsonData);
      var foreignLayers = doc.foreignSymbols ?? <ForeignSymbol>[];
      var pg = SketchPage('third_party_widgets');
      for (var layer in foreignLayers) {
        pg.addPageItem(SketchPageItem(layer.originalMaster, pg));
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

      var pg = SketchPage(jsonData['name']); // Sketch Node Holder
      var node = Page.fromJson(jsonData); // Actual Sketch Node

      // Turn layers into PBNodes
      for (var layer in node.layers) {
        pg.addPageItem(SketchPageItem(layer, pg));
      }
      sketchPages.add(pg);
    }
    return sketchPages;
  }

  Map<String, Object> toJson() {
    var result = <String, Object>{};
    result['projectName'] = projectName;
    for (var page in pages) {
      result.addAll(page.toJson());
    }
    for (var page in miscPages) {
      result.addAll(page.toJson());
    }
    return result;
  }
}
