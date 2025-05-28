part of 'api_request_bloc.dart';

enum ApiRequestStatus {
  initial,
  success,
  created,
  error,
  loading,
  sendingRequest,
}

class ApiRequestState extends Equatable {
  final ApiRequestStatus apiRequestStatus;
  final bool isGetRequest;
  final String api;
  final String apiName;
  final List<HeadersListModel> headers;
  final String payload;
  final String auth;
  final String selectedAuthType;
  final String basicAuthUsername;
  final String basicAuthPassword;
  final List<ParamsListModel> params;
  final String bearerToken;
  final http.Response? response;
  final String? message;
  const ApiRequestState({
    this.apiRequestStatus = ApiRequestStatus.initial,
    this.isGetRequest = true,
    this.api = '',
    this.apiName = '',
    this.headers = const [],
    this.payload = '',
    this.auth = '',
    this.params = const [],
    this.selectedAuthType = 'No Auth',
    this.basicAuthUsername = '',
    this.basicAuthPassword = '',
    this.bearerToken = '',
    this.response,
    this.message,
  });

  ApiRequestState copyWith({
    ApiRequestStatus? apiRequestStatus,
    bool? isGetRequest,
    String? api,
    String? apiName,
    List<HeadersListModel>? headers,
    String? payload,
    String? auth,
    List<ParamsListModel>? params,
    String? selectedAuthType,
    String? basicAuthUsername,
    String? basicAuthPassword,
    String? bearerToken,
    http.Response? response,
    String? message,
  }) => ApiRequestState(
    apiRequestStatus: apiRequestStatus ?? this.apiRequestStatus,
    isGetRequest: isGetRequest ?? this.isGetRequest,
    api: api ?? this.api,
    apiName: apiName ?? this.apiName,
    headers: headers ?? this.headers,
    payload: payload ?? this.payload,
    auth: auth ?? this.auth,
    params: params ?? this.params,
    response: response ?? this.response,
    selectedAuthType: selectedAuthType ?? this.selectedAuthType,
    basicAuthUsername: basicAuthUsername ?? this.basicAuthUsername,
    basicAuthPassword: basicAuthPassword ?? this.basicAuthPassword,
    bearerToken: bearerToken ?? this.bearerToken,
    message: message,
  );

  @override
  List<Object?> get props => [
    apiRequestStatus,
    isGetRequest,
    api,
    apiName,
    headers,
    payload,
    auth,
    params,
    response,
    selectedAuthType,
    basicAuthUsername,
    basicAuthPassword,
    bearerToken,
    message,
  ];
}
