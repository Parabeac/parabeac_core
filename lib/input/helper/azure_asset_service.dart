import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:azblob/azblob.dart';

class AzureAssetService {
  AzureAssetService._internal();

  static final AzureAssetService _instance = AzureAssetService._internal();

  factory AzureAssetService() => _instance;

  String _projectUUID;

  set projectUUID(String UUID) => _projectUUID = UUID;

  String get projectUUID => _projectUUID.toLowerCase();

  static const KEY_NAME = 'STORAGE_CONNECTION_STRING';

  String getImageURI(String imageName) => getContainerUri() + '/$imageName';

  String getContainerUri() {
    if (Platform.environment.containsKey(KEY_NAME) && projectUUID != null) {
      var storageStringList = Platform.environment[KEY_NAME].split(';');
      var protocol = storageStringList[0].split('=')[1];
      var accName = storageStringList[1].split('=')[1];
      var suffix = storageStringList.last.split('=')[1];
      return '$protocol://$accName.blob.$suffix/$projectUUID';
    }
    return '';
  }

  Future<http.StreamedResponse> _putRequestBlob(
      String path, Uint8List bodyBytes,
      {Map<String, String> queryParams}) async {
    var storage = AzureStorage.parse(Platform.environment[KEY_NAME]);
    var uri, headers;
    // Request
    if (queryParams == null) {
      uri = storage.uri(path: '$path');
      headers = {'x-ms-blob-type': 'BlockBlob'};
    } else {
      uri = storage.uri(path: '$path', queryParameters: queryParams);
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

  Future<http.StreamedResponse> createContainer(
          String container, Uint8List bodyBytes) async =>
      await _putRequestBlob('/$container', bodyBytes,
          queryParams: {'restype': 'container'});

  Future<http.StreamedResponse> putBlob(
          String container, String filename, Uint8List bodyBytes) async =>
      await _putRequestBlob('/$container/$filename', bodyBytes);

  Future<Uint8List> downloadImage(String uuid) async {
    var storage = AzureStorage.parse(Platform.environment[KEY_NAME]);
    var uri = storage.uri(path: '/$projectUUID/$uuid.png');

    var request = http.Request('GET', uri);
    storage.sign(request);

    var res = await request.send();
    return await res.stream.toBytes();
  }
}
