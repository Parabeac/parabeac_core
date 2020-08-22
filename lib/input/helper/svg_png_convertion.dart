import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:quick_log/quick_log.dart';

const svg_convertion_endpoint = 'http://localhost:4000/vector';

Logger log = Logger('Image conversion');

Future<Uint8List> convertImage(Map json) async {
  try {
    //Put the image on the top left corner
    json['frame'].x = 0.0;
    json['frame'].y = 0.0;
    var response = await http.post(
      svg_convertion_endpoint,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: jsonEncode(json),
    );
    return response?.bodyBytes;
  } catch (e) {
    log.error(e);
  }
  return null;
}
