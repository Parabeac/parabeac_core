import 'dart:io';
import 'dart:typed_data';

import 'package:parabeac_core/controllers/main_info.dart';

/// Singleton class that stores sketch node symbols for easy access
class ImageReferenceStorage {
  static final ImageReferenceStorage _singleInstance =
      ImageReferenceStorage._internal();

  ImageReferenceStorage._internal();

  /// Singleton class that stores sketch node symbols for easy access
  factory ImageReferenceStorage() {
    return _singleInstance;
  }

  final Map<String, String> images_references = {};

  Iterable<String> get names => images_references.keys;

  Iterable<String> get paths => images_references.values;

  /// Adds the reference to the image and writes the png to the assets folder.
  /// Returns true if the image was written successfully, false otherwise
  bool addReferenceAndWrite(String name, String path, Uint8List image) {
    if (image == null &&
        File('${MainInfo().cwd?.path}/lib/input/assets/image-conversion-error.png')
            .existsSync() &&
        addReference(name,
            '${MainInfo().cwd?.path}/lib/input/assets/image-conversion-error.png')) {
      File('${MainInfo().cwd?.path}/lib/input/assets/image-conversion-error.png')
          .copySync('${MainInfo().outputPath}pngs/${name}.png');
      return true;
    }
    if (addReference(name, path)) {
      var imgPath = '${MainInfo().outputPath}pngs/${name}.png';
      if (!File(imgPath).existsSync()) {
        File(imgPath).createSync(recursive: true);
      }
      File(imgPath).writeAsBytesSync(image);
      return true;
    }
    return false;
  }

  bool addReference(String name, String path) {
    if (name != null && path != null && name.isNotEmpty && path.isNotEmpty) {
      images_references[name] = path;
      return true;
    } else {
      return false;
    }
  }

  /// Removes the symbol with given [reference].
  /// Returns [true] if the object was successfuly removed,
  /// [false] if the object did not exist.
  bool removeImageByName(String name) {
    return (images_references.remove(name) != null);
  }

  /// Returns the symbol with the given [reference],
  /// or [null] if no such symbol exists.
  String getImagePathByReference(String name) {
    return images_references[name];
  }
}
