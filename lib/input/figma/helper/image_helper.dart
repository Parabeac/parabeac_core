import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:parabeac_core/APICaller/api_call_service.dart';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:quick_log/quick_log.dart';

List<String> uuidQueue = [];

Logger log = Logger('Figma Image helper');

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
        if (entry?.value != null && entry?.value.isNotEmpty) {
          response = await http.get(entry.value).then((imageRes) {
            // Check if the request was successful
            if (imageRes == null || imageRes.statusCode != 200) {
              log.error('Image ${entry.key} was not processed correctly');
            }

            var file = File('${MainInfo().outputPath}pngs/${entry.key}.png'
                .replaceAll(':', '_'));
            file.writeAsBytesSync(imageRes.bodyBytes);
            // TODO: Only print out when verbose flag is active
            // log.debug('File written to following path ${file.path}');
          }).catchError(log.error);
        }
      }
      return response;
    }
  });
  // TODO: Investigate API call for when values.first == null
}

Future<void> processImageQueue() async {
  // Split uuids into 6 lists to create separate API requests to figma
  List<List<String>> uuidLists = List.generate(8, (_) => []);
  for (var i = 0; i < uuidQueue.length; i++) {
    uuidLists[i % 8].add(uuidQueue[i]);
  }

  // Process images in separate queues
  List<Future> futures = [];
  for (var uuidList in uuidLists) {
    futures.add(_processImages(uuidList));
  }

  // Wait for the images to complete writing process
  await Future.wait(futures, eagerError: true);
}

mixin PBImageHelperMixin {
  /// Adds [uuid] to queue to be processed as an image.
  /// Returns the formatted name of the image reference.
  String addToImageQueue(String uuid) {
    uuidQueue.add(uuid);
    return ('images/' + uuid + '.png').replaceAll(':', '_');
  }
}
