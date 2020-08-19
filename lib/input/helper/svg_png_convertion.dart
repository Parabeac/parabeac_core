import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:parabeac_core/controllers/main_info.dart';

const svg_convertion_endpoint = 'http://localhost:5555';

Future<Uint8List> convertImage(String encodedJson) async {
  var response = await http.post(
    svg_convertion_endpoint,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: encodedJson,
  );
  return response.bodyBytes;
}
