import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:parabeac_core/APICaller/api_call_service.dart';
import 'package:parabeac_core/controllers/main_info.dart';

/// Downloads the image with the given `UUID`
/// and writes it to the `pngs` folder in the `outputPath`.
/// Returns true if the operation was successful. Returns false
/// otherwise.
Future<bool> writeImage(String UUID) async {
  // Call Figma API to get Image link
  var response = await APICallService.makeAPICall(
      'https://api.figma.com/v1/images/${MainInfo().figmaProjectID}?ids=$UUID',
      MainInfo().figmaKey);
  // Download image and write it to `pngs` folder
  if (response != null &&
      response.containsKey('images') &&
      response['images'].values.isNotEmpty) {
    var imageRes = await http.get(response['images'].values.first);

    // Check if the request was successful
    if (imageRes == null || imageRes.statusCode != 200) {
      return false;
    }

    File('${MainInfo().outputPath}/pngs/$UUID.png')
        .writeAsBytesSync(imageRes?.bodyBytes);
    return true;
  }
  return false;
}
