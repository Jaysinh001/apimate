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
