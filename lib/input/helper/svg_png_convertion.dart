import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:quick_log/quick_log.dart';

const svg_convertion_endpoint = 'http://localhost:4000/vector';
const svg_convertion_endpoint_local = 'http://localhost:4000/vector/local';

Logger log = Logger('Image conversion');

/// Converts the svg to png by passing the whole json map
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

/// Converts the svg to a png by passing the uuid to the local sketchtool
Future<Uint8List> convertImageLocal(String uuid) async {
  try {
    var body = {'uuid': uuid, 'path': MainInfo().sketchPath};

    var response = await http.post(
      svg_convertion_endpoint_local,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: jsonEncode(body),
    );
    return response?.bodyBytes;
  } catch (e) {
    log.error(e);
  }
  return null;
}
