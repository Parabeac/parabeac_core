import 'dart:io';
import 'dart:typed_data';

import 'package:parabeac_core/input/helper/azure_asset_service.dart';

abstract class AssetProcessingService {
  dynamic processImage(String uuid);

  Future<void> processRootElements(Map uuids);

  AzureAssetService aaService = AzureAssetService();

  static String getImageName(String uuid) =>
      ('images/' + uuid + '.png').replaceAll(':', '_');

  Future<void> uploadToStorage(Uint8List img, String name) async {
    if (Platform.environment.containsKey(AzureAssetService.KEY_NAME) &&
        aaService.projectUUID != null) {
      // Upload image to storage

      var cont = await aaService.createContainer(
        aaService.projectUUID,
        img,
      );
      var blob = await aaService.putBlob(
        aaService.projectUUID,
        '$name.png',
        img,
      );
      await cont.stream.drain();
      await blob.stream.drain();
    }
  }
}
