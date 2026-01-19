part of 'request_client_bloc.dart';



abstract class RequestClientEvent extends Equatable {
  const RequestClientEvent();

  @override
  List<Object?> get props => [];
}


class LoadRequestDetails extends RequestClientEvent {
  final int requestId;

  const LoadRequestDetails({required this.requestId});

  @override
  List<Object?> get props => [requestId];
}


class SendRequest extends RequestClientEvent {
  const SendRequest();
}


class RefreshResolvedRequest extends RequestClientEvent {
  const RefreshResolvedRequest();
}

class AddHeader extends RequestClientEvent {
  final String key;
  final String value;

  const AddHeader({required this.key, required this.value});

  @override
  List<Object?> get props => [key, value];
}

class UpdateHeader extends RequestClientEvent {
  final String key;
  final String value;

  const UpdateHeader({required this.key, required this.value});

  @override
  List<Object?> get props => [key, value];
}

class RemoveHeader extends RequestClientEvent {
  final String key;

  const RemoveHeader({required this.key});

  @override
  List<Object?> get props => [key];
}


class UpdateAuthType extends RequestClientEvent {
  final AuthType type;
  const UpdateAuthType(this.type);

     @override
  List<Object?> get props => [type];
}

class UpdateBearerToken extends RequestClientEvent {
  final String token;
  const UpdateBearerToken(this.token);

     @override
  List<Object?> get props => [token];
}

class UpdateApiKey extends RequestClientEvent {
  final String key;
  const UpdateApiKey({required this.key});

     @override
  List<Object?> get props => [key];
}

class UpdateApiValue extends RequestClientEvent {
  final String value;
  const UpdateApiValue({required this.value});


     @override
  List<Object?> get props => [value];
}

class UpdateApiLocation extends RequestClientEvent {
  final ApiKeyLocation location;
  const UpdateApiLocation(this.location);

     @override
  List<Object?> get props => [location];
}

class UpdateBasicUsername extends RequestClientEvent {
  final String username;
  const UpdateBasicUsername(this.username);

   @override
  List<Object?> get props => [username];
}

class UpdateBasicPassword extends RequestClientEvent {
  final String password;
  const UpdateBasicPassword(this.password);

   @override
  List<Object?> get props => [password];
}



class AddQueryParam extends RequestClientEvent {
  final String key;
  final String value;

  const AddQueryParam({required this.key, required this.value});

  @override
  List<Object?> get props => [key, value];
}

class UpdateQueryParam extends RequestClientEvent {
  final String key;
  final String value;

  const UpdateQueryParam({required this.key, required this.value});

  @override
  List<Object?> get props => [key, value];
}

class RemoveQueryParam extends RequestClientEvent {
  final String key;

  const RemoveQueryParam({required this.key});

  @override
  List<Object?> get props => [key];
}

class UpdateRequestBody extends RequestClientEvent {
  final String body;
  final String? contentType;

  const UpdateRequestBody({
    required this.body,
    this.contentType,
  });

  @override
  List<Object?> get props => [body, contentType];
}

class UpdateResolvedUrl extends RequestClientEvent {
  final String url;
  const UpdateResolvedUrl(this.url);

  @override
  List<Object?> get props => [url];
}


class SaveResponse extends RequestClientEvent {
  const SaveResponse();
}

class SaveRequestDraft extends RequestClientEvent {
  const SaveRequestDraft();
}

