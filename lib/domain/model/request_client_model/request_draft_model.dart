import 'package:equatable/equatable.dart';

import 'request_auth_model.dart';

class RequestDraft extends Equatable {
  final String method;
  final String rawUrl;

  /// Editable components
  final Map<String, String> headers;
  final Map<String, String> queryParams;
  final RequestAuth auth;
  final String? body;
  final String? contentType;

  const RequestDraft({
    required this.method,
    required this.rawUrl,
    required this.auth,
    required this.headers,
    required this.queryParams,
    this.body,
    this.contentType,
  });

  /// Create initial draft from DB-loaded data
  factory RequestDraft.fromLoadedData({
    required String method,
    required String rawUrl,
    required Map<String, String> headers,
    required Map<String, String> queryParams,
    required RequestAuth auth,
    String? body,
    String? contentType,
  }) {
    return RequestDraft(
      method: method,
      rawUrl: rawUrl,
      auth: auth,
      headers: Map<String, String>.from(headers),
      queryParams: Map<String, String>.from(queryParams),
      body: body,
      contentType: contentType,
    );
  }

  /// Copy helpers (immutability-friendly)
  RequestDraft copyWith({
    Map<String, String>? headers,
    Map<String, String>? queryParams,
    String? body,
    RequestAuth? auth,
    String? rawUrl,
    String? contentType,
  }) {
    return RequestDraft(
      method: method,
      rawUrl: rawUrl ?? this.rawUrl,
      headers: headers ?? this.headers,
      auth: auth ?? this.auth,
      queryParams: queryParams ?? this.queryParams,
      body: body ?? this.body,
      contentType: contentType ?? this.contentType,
    );
  }

  @override
  List<Object?> get props => [
    method,
    rawUrl,
    headers,
    auth,
    queryParams,
    body,
    contentType,
  ];
}
