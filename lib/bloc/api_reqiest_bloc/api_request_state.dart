part of 'api_request_bloc.dart';

enum ApiRequestStatus { initial, success, error, loading }

class ApiRequestState extends Equatable {
  final ApiRequestStatus apiRequestStatus;
  final bool isGetRequest;
  final String api;
  final String headers;
  final String payload;
  final String? message;
  const ApiRequestState({
    this.apiRequestStatus = ApiRequestStatus.initial,
    this.isGetRequest = true,
    this.api = '',
    this.headers = '',
    this.payload = '',
    this.message,
  });

  ApiRequestState copyWith({
    ApiRequestStatus? apiRequestStatus,
    bool? isGetRequest,
    String? api,
    String? headers,
    String? payload,
    String? message,
  }) => ApiRequestState(
    apiRequestStatus: apiRequestStatus ?? this.apiRequestStatus,
    isGetRequest: isGetRequest ?? this.isGetRequest,
    api: api ?? this.api,
    headers: headers ?? this.headers,
    payload: payload ?? this.payload,
    message: message,
  );

  @override
  List<Object?> get props => [
    apiRequestStatus,
    isGetRequest,
    api,
    headers,
    payload,
    message,
  ];
}
