import 'dart:io';
import 'dart:typed_data';
import 'package:azblob/azblob.dart';
import 'package:http/http.dart' as http;

abstract class AssetProcessingService {
  String projectUUID;

  dynamic processImage(String uuid);

  Future<void> processRootElements(Map uuids);

  static const KEY_NAME = 'STORAGE_CONNECTION_STRING';

  Future<void> uploadToStorage(Uint8List img, String name) async {
    if (Platform.environment.containsKey(KEY_NAME) && projectUUID != null) {
      // Upload image to storage
      var storage = AzureStorage.parse(Platform.environment[KEY_NAME]);
      var cont = await _createContainer(
        storage,
        projectUUID.toLowerCase(),
        img,
      );
      var blob = await _putBlob(
        storage,
        projectUUID.toLowerCase(),
        '${name}.png',
        img,
      );
      await cont.stream.drain();
      await blob.stream.drain();
    }
  }

  Future<http.StreamedResponse> _putRequestBlob(
      AzureStorage storage, String path, Uint8List bodyBytes,
      {Map<String, String> queryParams}) async {
    var uri, headers;
    // Request
    if (queryParams == null) {
      uri = storage.uri(path: '${path}');
      headers = {'x-ms-blob-type': 'BlockBlob'};
    } else {
      uri = storage.uri(path: '${path}', queryParameters: queryParams);
    }

    var request = http.Request('PUT', uri);
    if (headers != null) {
      request.headers.addAll(headers);
    }
    request.bodyBytes = bodyBytes;
    storage.sign(request);

    var res = await request.send();
    return res;
  }

  Future<http.StreamedResponse> _createContainer(
          AzureStorage storage, String container, Uint8List bodyBytes) async =>
      await _putRequestBlob(storage, '/${container}', bodyBytes,
          queryParams: {'restype': 'container'});

  Future<http.StreamedResponse> _putBlob(AzureStorage storage, String container,
          String filename, Uint8List bodyBytes) async =>
      await _putRequestBlob(storage, '/${container}/${filename}', bodyBytes);
}
