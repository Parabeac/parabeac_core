import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http2/http2.dart';
import 'package:quick_log/quick_log.dart';

import 'api_exceptions.dart';

class APICallService {
  APICallService();
  var log = Logger('API Call Service');

  Future<dynamic> makeAPICall(List<String> args) async {
    var response;
    var uri = Uri.parse('${args[0]}');

    try {
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
            // print('Header: $name: $value');
            if (name == ':status') {
              _returnResponse(int.parse(value));
            }
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
    } catch (e) {
      print(e);
    }
  }

  dynamic _returnResponse(int status) {
    switch (status) {
      case 200:
        log.fine('API call went successfully : ${status}');
        break;
      case 400:
        log.error('BadRequestException : ${status}');
        throw BadRequestException();
        break;
      case 401:
      case 403:
        log.error('UnauthorisedException : ${status}');
        throw UnauthorisedException();
        break;
      case 500:
      default:
        log.error(
            'Error occured while Communication with Server with StatusCode : ${status}');
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${status}');
        break;
    }
  }
}
