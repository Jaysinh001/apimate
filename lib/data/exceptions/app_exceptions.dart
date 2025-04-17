class AppExceptions implements Exception {
  final _message;
  final _prefix;

  AppExceptions([this._message, this._prefix]);

  @override
  String toString() {
    return '$_message $_prefix';
  }
}

class NoInternetConnection extends AppExceptions {
  NoInternetConnection([String? message])
      : super(message, 'No Internet Connection!');
}

class UnAuthorizedException extends AppExceptions {
  UnAuthorizedException([String? message])
      : super(message, 'UnAuthorized User!');
}

class RequestTimeOutException extends AppExceptions {
  RequestTimeOutException([String? message])
      : super(message, 'Request Exceeds time!');
}

class FetchDataException extends AppExceptions {
  FetchDataException([String? message])
      : super(message, 'Fetching Data Exception!');
}

/// ===============>>>> WebSocket Exceptions <<<<========================

class WebSocketConnectionException implements Exception {
  final String message;

  WebSocketConnectionException(this.message);

  @override
  String toString() => 'WebSocketConnectionException: $message';
}

class WebSocketListeningException implements Exception {
  final String message;

  WebSocketListeningException(this.message);

  @override
  String toString() => 'WebSocketListeningException: $message';
}

class WebSocketSendingException implements Exception {
  final String message;

  WebSocketSendingException(this.message);

  @override
  String toString() => 'WebSocketSendingException: $message';
}

class WebSocketClosingException implements Exception {
  final String message;

  WebSocketClosingException(this.message);

  @override
  String toString() => 'WebSocketClosingException: $message';
}
