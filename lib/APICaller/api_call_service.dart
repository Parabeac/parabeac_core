import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http2/http2.dart';

import 'api_exceptions.dart';

class APICallService {
  APICallService();

  Future<dynamic> makeAPICall(List<String> args) async {
    var response;
    var uri = Uri.parse("${args[0]}");

    var transport = ClientTransportConnection.viaSocket(
      await SecureSocket.connect(
        uri.host,
        uri.port,
        supportedProtocols: ['h2'],
      ),
    );

    var stream = transport.makeRequest(
      [
        Header.ascii(':method', 'GET'),
        Header.ascii(':path', uri.path),
        Header.ascii(':scheme', uri.scheme),
        Header.ascii(':authority', uri.host),
        Header.ascii('x-figma-token', args[1]),
      ],
      endStream: true,
    );

    final buffer = StringBuffer();
    await for (var message in stream.incomingMessages) {
      if (message is HeadersStreamMessage) {
        for (var header in message.headers) {
          var name = utf8.decode(header.name);
          var value = utf8.decode(header.value);
          print('Header: $name: $value');
        }
      } else if (message is DataStreamMessage) {
        // Use [message.bytes] (but respect 'content-encoding' header)
        buffer.write(utf8.decode(message.bytes));
      }
    }
    await transport.finish();
    var map = buffer.toString();
    response = json.decode(map);
    return response;
  }

  /// TODO: Adapt it to the new http2 or remove it
  // dynamic _returnResponse(http.Response response) {
  //   switch (response.statusCode) {
  //     case 200:
  //       return response;
  //     case 400:
  //       throw BadRequestException(response.body.toString());
  //     case 401:
  //     case 403:
  //       throw UnauthorisedException(response.body.toString());
  //     case 500:
  //     default:
  //       throw FetchDataException(
  //           'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
  //   }
  // }
}
