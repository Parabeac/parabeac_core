import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:parabeac_core/APICaller/api_call_service.dart';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/input/helper/asset_processing_service.dart';
import 'package:quick_log/quick_log.dart';

class FigmaAssetProcessor extends AssetProcessingService {
  FigmaAssetProcessor._internal();

  static final FigmaAssetProcessor _instance = FigmaAssetProcessor._internal();

  factory FigmaAssetProcessor() => _instance;

  final List<String> _uuidQueue = [];

  List<String> get uuidQueue => _uuidQueue;

  Logger log = Logger('Figma Image helper');

  /// Adds [uuid] to queue to be processed as an image.
  /// Returns the formatted name of the image reference.
  @override
  String processImage(String uuid) {
    _uuidQueue.add(uuid);
    return ('images/' + uuid + '.png').replaceAll(':', '_');
  }

  /// Creates separate API requests from `uuidQueue` to speed up
  /// the image downloading process.
  Future<void> processImageQueue() async {
    List<List<String>> uuidLists;
    if (_uuidQueue.length >= 8) {
      // Split uuids into 8 lists to create separate API requests to figma
      uuidLists = List.generate(8, (_) => []);
      for (var i = 0; i < _uuidQueue.length; i++) {
        uuidLists[i % 8].add(_uuidQueue[i]);
      }
    } else {
      uuidLists = [_uuidQueue];
    }

    // Process images in separate queues
    var futures = <Future>[];
    for (var uuidList in uuidLists) {
      futures.add(_processImages(uuidList));
    }

    // Wait for the images to complete writing process
    await Future.wait(futures, eagerError: true);
  }

  /// Downloads the image with the given `UUID`
  /// and writes it to the `pngs` folder in the `outputPath`.
  /// Returns true if the operation was successful. Returns false
  /// otherwise.
  Future<dynamic> _processImages(List<String> uuids) async {
    // Call Figma API to get Image link
    return Future(() async {
      var response = await APICallService.makeAPICall(
          'https://api.figma.com/v1/images/${MainInfo().figmaProjectID}?ids=${uuids.join(',')}',
          MainInfo().figmaKey);

      if (response != null &&
          response.containsKey('images') &&
          response['images'] != null &&
          response['images'].values.isNotEmpty) {
        Map images = response['images'];
        // Download the images
        for (var entry in images.entries) {
          if (entry?.value != null && entry?.value?.isNotEmpty) {
            response = await http.get(entry.value).then((imageRes) {
              // Check if the request was successful
              if (imageRes == null || imageRes.statusCode != 200) {
                log.error('Image ${entry.key} was not processed correctly');
              }

              var file = File('${MainInfo().outputPath}pngs/${entry.key}.png'
                  .replaceAll(':', '_'))
                ..createSync(recursive: true);
              file.writeAsBytesSync(imageRes.bodyBytes);
              // TODO: Only print out when verbose flag is active
              // log.debug('File written to following path ${file.path}');
            }).catchError((e) => log.error(e.toString()));
          }
        }
        return response;
      }
    });
  }

  @override
  Future<void> processRootElements(List<String> uuids) {
    // TODO: implement processRootElements
    throw UnimplementedError();
  }
}
