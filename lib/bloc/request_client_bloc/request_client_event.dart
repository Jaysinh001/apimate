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
