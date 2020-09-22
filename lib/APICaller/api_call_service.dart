import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'api_exceptions.dart';

class APICallService {
  APICallService();

  Future<dynamic> makeAPICall(List<String> args) async {
    var response;
    try {
      /// TODO: plug logger in here
      var tempResponse =
          await http.get("https://api.figma.com/v1/files/${args[0]}", headers: {
        'X-Figma-Token': '${args[1]}',
      });
      if (tempResponse.statusCode == 400) {
        var qFix = File('tempJson.json');
        response = qFix.readAsStringSync().toString();
      } else {
        response = _returnResponse(tempResponse);
      }
    } on SocketException {
      print('No internet connection.');
    }
    return json.decode(response);
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return response;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
