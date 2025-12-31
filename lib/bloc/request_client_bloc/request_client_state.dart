
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

  /// Immutable request identity
  final int? requestId;

  /// 🔑 Editable in-memory request
  final RequestDraft? draft;

  /// Variable resolution preview
  final String? resolvedUrl;
  final List<String> variableWarnings;

  /// Last execution result
  final RequestResponse? lastResponse;

  final String? message;

  const RequestClientState({
    this.status = RequestClientStatus.initial,
    this.requestId,
    this.draft,
    this.resolvedUrl,
    this.variableWarnings = const [],
    this.lastResponse,
    this.message,
  });

  RequestClientState copyWith({
    RequestClientStatus? status,
    int? requestId,
    RequestDraft? draft,
    String? resolvedUrl,
    List<String>? variableWarnings,
    RequestResponse? lastResponse,
    String? message,
  }) {
    return RequestClientState(
      status: status ?? this.status,
      requestId: requestId ?? this.requestId,
      draft: draft ?? this.draft,
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
        draft,
        resolvedUrl,
        variableWarnings,
        lastResponse,
        message,
      ];
}
