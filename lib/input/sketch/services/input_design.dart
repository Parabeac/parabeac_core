import 'dart:convert';
import 'dart:io';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/input/sketch/helper/sketch_page.dart';
import 'package:path/path.dart';
import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;

/// Takes Initial Design File and puts it into a tree in object format.
/// Currently only supports Sketch Files
///Class used to process the contents of a sketch file
class InputDesignService {
  final String pathToFile;
  final String IMAGE_DIR_NAME = 'images/';

  String get filename => basename(File(pathToFile).path);
  List<SketchPage> sketchPages = [];

  Archive _archive;

  InputDesignService(this.pathToFile, {bool jsonOnly = false}) {
    _archive = _unzip(File(pathToFile));
    if (!jsonOnly) {
      setImageDir();
    }
  }

  ///The archive of the unzipped sketch project
  Archive get archive => _archive;

  ///The json-decoded meta.json file inside the sketch project
  Map get metaFileJson {
    final metaFile = archive.findFile('meta.json').content;
    return json.decode(utf8.decode(metaFile));
  }

  Map get documentFile {
    final doc_page = archive.findFile('document.json').content;
    assert(doc_page != null, "Document page from Sketch doesn't exist.");
    final doc_map = json.decode(utf8.decode(doc_page));
    return doc_map;
  }

  ///Getting the images in the sketch file and adding them to the png folder.
  void setImageDir() {
    ///Creating the pngs folder, if it's already not there.
    var pngsPath = p.join(MainInfo().outputPath, 'pngs');
    Directory(pngsPath).createSync(recursive: true);
    for (final file in archive) {
      final fileName = file.name;
      if (file.isFile && fileName.contains(IMAGE_DIR_NAME)) {
        final data = file.content as List<int>;
        final name = fileName.replaceAll(IMAGE_DIR_NAME, '');
        File(p.join(pngsPath, name)).writeAsBytesSync(data);
      }
    }
  }

  ///Unzips the file and returns the archive
  Archive _unzip(File f) {
    List<int> bytes = f.readAsBytesSync();
    return ZipDecoder().decodeBytes(bytes);
  }
}
