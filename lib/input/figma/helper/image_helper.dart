import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:parabeac_core/APICaller/api_call_service.dart';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:quick_log/quick_log.dart';

List<String> uuidQueue = [];

Logger log = Logger('Image helper');

/// Downloads the image with the given `UUID`
/// and writes it to the `pngs` folder in the `outputPath`.
/// Returns true if the operation was successful. Returns false
/// otherwise.
/// //TODO: figure out return type
Future<dynamic> processImages(List<String> uuids) async {
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
            log.fine('File written to following path ${file.path}');
          }).catchError(print);
        }
      }
      return response;
    }
  });
  // TODO: Investigate API call for when values.first == null
}
