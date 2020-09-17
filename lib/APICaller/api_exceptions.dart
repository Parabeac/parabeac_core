class APIException implements Exception {
  final _message;
  final _prefix;
  APIException([this._message, this._prefix]);
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends APIException {
  FetchDataException([String message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends APIException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends APIException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends APIException {
  InvalidInputException([String message]) : super(message, "Invalid Input: ");
}
