import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/input/helper/asset_processing_service.dart';
import 'package:quick_log/quick_log.dart';

class SketchAssetProcessor implements AssetProcessingService {
  final svg_convertion_endpoint =
      Platform.environment.containsKey('SAC_ENDPOINT')
          ? Platform.environment['SAC_ENDPOINT']
          : 'http://localhost:4000/vector/local';

  Logger log = Logger('Image conversion');

  SketchAssetProcessor._internal();

  static final SketchAssetProcessor _instance =
      SketchAssetProcessor._internal();

  factory SketchAssetProcessor() => _instance;

  String getBlobName(String path) => path.split('/').last;

  /// Converts an svg with `uuid` from a sketch file to a png with specified
  /// `width` and `height`
  @override
  Future<Uint8List> processImage(String uuid, [int width, int height]) async {
    try {
      var body = Platform.environment.containsKey('SAC_ENDPOINT')
          ? {
              'uuid': uuid,
              'width': width,
              'height': height,
              'blob': getBlobName(MainInfo().sketchPath),
              'container': 'design-file'
            }
          : {
              'uuid': uuid,
              'path': MainInfo().sketchPath,
              'width': width,
              'height': height
            };

      var response = await http
          .post(
            svg_convertion_endpoint,
            headers: {HttpHeaders.contentTypeHeader: 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(Duration(minutes: 1));

      if (response.statusCode >= 400) {
        var bodyMap = jsonDecode(response.body);
        log.error(bodyMap['error']);
      }
      return response?.bodyBytes;
    } catch (e) {
      log.error(e.message);
    }
    return null;
  }

  @override
  Future<void> processRootElements(List<String> uuids) {
    // TODO: implement processRootElements
    throw UnimplementedError();
  }
}
