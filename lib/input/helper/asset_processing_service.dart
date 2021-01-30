import 'dart:io';
import 'dart:typed_data';
import 'package:azblob/azblob.dart';

abstract class AssetProcessingService {
  String projectUUID;

  dynamic processImage(String uuid);

  Future<void> processRootElements(List<String> uuids);

  Future<void> uploadToStorage(Uint8List img, String name) async {
    if (Platform.environment.containsKey('STORAGE_KEY') &&
        projectUUID != null) {
      // Upload image to storage
      var storage = AzureStorage.parse(Platform.environment['STORAGE_KEY']);
      await storage.putBlob(
        '/${projectUUID}/${name}.png',
        body: img.toString(),
      );
    }
  }
}
