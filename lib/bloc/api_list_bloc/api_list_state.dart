part of 'api_list_bloc.dart';

enum ApiListStatus { initial, loading, success, error }

class ApiListState extends Equatable {
  final ApiListStatus apiListStatus;
  final List<GetApiListModel> apiList;
  final String? message;
  const ApiListState({
    this.apiListStatus = ApiListStatus.initial,
    this.apiList = const [],
    this.message,
  });

  ApiListState copyWith({
    ApiListStatus? apiListStatus,
    List<GetApiListModel>? apiList,
    String? message,
  }) => ApiListState(
    apiListStatus: apiListStatus ?? this.apiListStatus,
    apiList: apiList ?? this.apiList,
    message: message,
  );

  @override
  List<Object?> get props => [apiListStatus, apiList, message];
}
