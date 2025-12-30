
part of 'request_client_bloc.dart';
enum RequestClientStatus {
  initial,
  loading,
  ready,
  sending,
  success,
  error,
}




class RequestClientState extends Equatable {
  final RequestClientStatus status;

  final int? requestId;
  final String? method;

  final String? rawUrl;
  final String? resolvedUrl;

  final List<String> variableWarnings;

  final RequestResponse? lastResponse;

  final String? message;

  const RequestClientState({
    this.status = RequestClientStatus.initial,
    this.requestId,
    this.method,
    this.rawUrl,
    this.resolvedUrl,
    this.variableWarnings = const [],
    this.lastResponse,
    this.message,
  });

  RequestClientState copyWith({
    RequestClientStatus? status,
    int? requestId,
    String? method,
    String? rawUrl,
    String? resolvedUrl,
    List<String>? variableWarnings,
    RequestResponse? lastResponse,
    String? message,
  }) {
    return RequestClientState(
      status: status ?? this.status,
      requestId: requestId ?? this.requestId,
      method: method ?? this.method,
      rawUrl: rawUrl ?? this.rawUrl,
      resolvedUrl: resolvedUrl ?? this.resolvedUrl,
      variableWarnings: variableWarnings ?? this.variableWarnings,
      lastResponse: lastResponse ?? this.lastResponse,
      message: message,
    );
  }

  @override
  List<Object?> get props => [
        status,
        requestId,
        method,
        rawUrl,
        resolvedUrl,
        variableWarnings,
        lastResponse,
        message,
      ];
}
