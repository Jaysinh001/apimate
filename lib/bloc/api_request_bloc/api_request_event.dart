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

// >>>>>>>>>>>>>>>>>>>>>>>>>> Params Events <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

class GetApiParams extends ApiRequestEvent {
  final int apiID;

  const GetApiParams({required this.apiID});

  @override
  List<Object?> get props => [apiID];
}

class AddParams extends ApiRequestEvent {
  final int apiID;
  final String key;
  final String value;

  const AddParams({
    required this.apiID,
    required this.key,
    required this.value,
  });

  @override
  List<Object?> get props => [apiID, key, value];
}

class DeleteParams extends ApiRequestEvent {
  final int id;

  const DeleteParams({required this.id});

  @override
  List<Object?> get props => [id];
}

// >>>>>>>>>>>>>>>>>>>>>>>>>> Authorization Events <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

class AuthChanged extends ApiRequestEvent {
  final String auth;

  const AuthChanged({required this.auth});

  @override
  List<Object?> get props => [auth];
}

// >>>>>>>>>>>>>>>>>>>>>>>>>> Headers Events <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

class GetApiHeaders extends ApiRequestEvent {
  final int apiID;

  const GetApiHeaders({required this.apiID});

  @override
  List<Object?> get props => [apiID];
}

class AddHeader extends ApiRequestEvent {
  final int apiID;
  final String key;
  final String value;

  const AddHeader({
    required this.apiID,
    required this.key,
    required this.value,
  });

  @override
  List<Object?> get props => [apiID, key, value];
}

class DeleteHeader extends ApiRequestEvent {
  final int id;

  const DeleteHeader({required this.id});

  @override
  List<Object?> get props => [id];
}

// >>>>>>>>>>>>>>>>>>>>>>>>>> Body Events <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

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
  final String? name;
  const LoadSelectedApiData({this.api, this.name});

  @override
  List<Object?> get props => [api, name];
}

class SaveApiToLocalDB extends ApiRequestEvent {
  final int apiID;
  final String? name;
  const SaveApiToLocalDB({this.name, required this.apiID});

  @override
  List<Object?> get props => [apiID, name];
}
