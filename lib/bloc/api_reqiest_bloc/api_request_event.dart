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
