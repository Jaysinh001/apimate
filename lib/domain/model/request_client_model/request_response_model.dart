import 'package:equatable/equatable.dart';

class RequestResponse extends Equatable {
  final int id;                 // DB id (0 if not saved yet)
  final int requestId;          // FK to requests table

  // HTTP metadata
  final int? statusCode;
  final String? statusMessage;
  final int durationMs;

  // Response data
  final Map<String, String> headers;
  final String body;

  // Error info (if request failed)
  final bool isError;
  final String? errorMessage;

  // Timestamps
  final DateTime createdAt;

  const RequestResponse({
    required this.id,
    required this.requestId,
    required this.durationMs,
    required this.headers,
    required this.body,
    required this.createdAt,
    this.statusCode,
    this.statusMessage,
    this.isError = false,
    this.errorMessage,
  });

  /// Convenience getters
  bool get isSuccess =>
      !isError && statusCode != null && statusCode! >= 200 && statusCode! < 300;

  bool get hasBody => body.isNotEmpty;

  @override
  List<Object?> get props => [
        id,
        requestId,
        statusCode,
        statusMessage,
        durationMs,
        headers,
        body,
        isError,
        errorMessage,
        createdAt,
      ];
}
