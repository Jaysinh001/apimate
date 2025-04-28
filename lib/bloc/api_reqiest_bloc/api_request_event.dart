part of 'api_request_bloc.dart';

class ApiRequestEvent extends Equatable {
  const ApiRequestEvent();

  @override
  List<Object?> get props => [];
}

class ToggleRequestType extends ApiRequestEvent {
  final bool isGetRequest;

  const ToggleRequestType({required this.isGetRequest});

  @override
  List<Object?> get props => [isGetRequest];
}

class ApiTextChanged extends ApiRequestEvent {
  final String api;

  const ApiTextChanged({required this.api});

  @override
  List<Object?> get props => [api];
}

class ParamsChanged extends ApiRequestEvent {
  final String params;

  const ParamsChanged({required this.params});

  @override
  List<Object?> get props => [params];
}

class AuthChanged extends ApiRequestEvent {
  final String auth;

  const AuthChanged({required this.auth});

  @override
  List<Object?> get props => [auth];
}

class HeadersChanged extends ApiRequestEvent {
  final String header;

  const HeadersChanged({required this.header});

  @override
  List<Object?> get props => [header];
}

class BodyChanged extends ApiRequestEvent {
  final String body;

  const BodyChanged({required this.body});

  @override
  List<Object?> get props => [body];
}

class SendApiRequest extends ApiRequestEvent {
  const SendApiRequest();

  @override
  List<Object?> get props => [];
}

class SelectAuthType extends ApiRequestEvent {
  final String? authType;
  const SelectAuthType({this.authType});

  @override
  List<Object?> get props => [authType];
}

class BearerTokenChanged extends ApiRequestEvent {
  final String? token;
  const BearerTokenChanged({this.token});

  @override
  List<Object?> get props => [token];
}

class BasicAuthUsernameChanged extends ApiRequestEvent {
  final String? username;
  const BasicAuthUsernameChanged({this.username});

  @override
  List<Object?> get props => [username];
}

class BasicAuthPasswordChanged extends ApiRequestEvent {
  final String? password;
  const BasicAuthPasswordChanged({this.password});

  @override
  List<Object?> get props => [password];
}

class LoadSelectedApiData extends ApiRequestEvent {
  final GetApiListModel? api;
  const LoadSelectedApiData({this.api});

  @override
  List<Object?> get props => [api];
}

class SaveApiToLocalDB extends ApiRequestEvent {
  final int? apiID;
  const SaveApiToLocalDB({this.apiID});

  @override
  List<Object?> get props => [apiID];
}
