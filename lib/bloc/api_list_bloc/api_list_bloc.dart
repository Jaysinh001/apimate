import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../config/utility/utility.dart';
import '../../domain/model/get_api_list_model.dart';
import '../../main.dart';

part 'api_list_event.dart';
part 'api_list_state.dart';

class ApiListBloc extends Bloc<ApiListEvent, ApiListState> {
  ApiListBloc() : super(const ApiListState()) {
    on<GetApiList>(handleGetApiList);
    on<CreateNewApi>(handleCreateNewApi);
    on<DeleteApi>(handleDeleteApi);
  }

  FutureOr<void> handleGetApiList(
    GetApiList event,
    Emitter<ApiListState> emit,
  ) async {
    emit(state.copyWith(apiListStatus: ApiListStatus.loading));

    try {
      final query = '''SELECT * FROM apis WHERE collection_id = ?''';

      final res = await databaseService?.executeQuery(
        sqlQuery: query,
        arguments: [
          event.id, // collection id
        ],
      );

      Utility.showLog("handleGetApiList ::: $res");

      final apiList = getApiListModelFromJson(jsonEncode(res));

      Utility.showLog("getApiListModelFromJson ::: $apiList");

      emit(
        state.copyWith(apiListStatus: ApiListStatus.success, apiList: apiList),
      );
    } catch (e) {
      Utility.showLog("handleGetApiList Exception ::: $e");

      emit(
        state.copyWith(
          apiListStatus: ApiListStatus.error,
          message: "Something went wrong!",
        ),
      );
    }
  }

  FutureOr<void> handleCreateNewApi(
    CreateNewApi event,
    Emitter<ApiListState> emit,
  ) async {
    emit(state.copyWith(apiListStatus: ApiListStatus.loading));

    try {
      final query =
          '''INSERT INTO apis (name, collection_id, method, url, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)''';

      final res = await databaseService?.executeQuery(
        sqlQuery: query,
        arguments: [
          "Untitled Request",
          event.collectionID,
          "GET",
          "", // EMPTY URL
          DateTime.now().toIso8601String(),
          DateTime.now().toIso8601String(),
        ],
      );

      Utility.showLog("handleCreateNewApi ::: $res");

      if (res is int) {
        GetApiListModel newApi = GetApiListModel(
          id: res,
          name: "Untitled Request",
          collectionId: event.collectionID,
          method: "GET",
          url: "",
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        emit(
          state.copyWith(
            apiListStatus: ApiListStatus.created,
            newApiRequest: newApi,
          ),
        );
      }
    } catch (e) {
      Utility.showLog("handleCreateNewApi Exception ::: $e");

      emit(
        state.copyWith(
          apiListStatus: ApiListStatus.error,
          message: "Something went wrong!",
        ),
      );
    }
  }

  FutureOr<void> handleDeleteApi(
    DeleteApi event,
    Emitter<ApiListState> emit,
  ) async {
    emit(state.copyWith(apiListStatus: ApiListStatus.loading));

    try {
      final query = '''DELETE FROM apis WHERE id = ?''';

      final res = await databaseService?.executeQuery(
        sqlQuery: query,
        arguments: [
          event.id, // api id
        ],
      );

      if (res == 1) {
        state.apiList.removeWhere((element) => element.id == event.id);

        emit(state.copyWith(apiListStatus: ApiListStatus.success));
      }

      emit(state.copyWith(apiListStatus: ApiListStatus.success));
    } catch (e) {
      Utility.showLog("handleGetApiList Exception ::: $e");

      emit(
        state.copyWith(
          apiListStatus: ApiListStatus.error,
          message: "Something went wrong!",
        ),
      );
    }
  }
}
