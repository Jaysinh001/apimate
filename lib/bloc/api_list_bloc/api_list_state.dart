part of 'api_list_bloc.dart';

enum ApiListStatus { initial, loading, success, error, created }

class ApiListState extends Equatable {
  final ApiListStatus apiListStatus;
  final List<GetApiListModel> apiList;
  final GetApiListModel? newApiRequest;
  final String? message;
  const ApiListState({
    this.apiListStatus = ApiListStatus.initial,
    this.apiList = const [],
    this.newApiRequest,
    this.message,
  });

  ApiListState copyWith({
    ApiListStatus? apiListStatus,
    List<GetApiListModel>? apiList,
    GetApiListModel? newApiRequest,
    String? message,
  }) => ApiListState(
    apiListStatus: apiListStatus ?? this.apiListStatus,
    apiList: apiList ?? this.apiList,
    newApiRequest: newApiRequest,
    message: message,
  );

  @override
  List<Object?> get props => [apiListStatus, apiList, newApiRequest, message];
}
