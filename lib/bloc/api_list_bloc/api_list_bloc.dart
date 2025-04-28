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
  }

  FutureOr<void> handleGetApiList(
    GetApiList event,
    Emitter<ApiListState> emit,
  ) async {
    emit(state.copyWith(apiListStatus: ApiListStatus.loading));

    try {
      final query = '''SELECT * FROM apis WHERE collection_id = ?''';
      // final query = '''DELETE FROM apis WHERE collection_id = ?''';
      // final query =
      //     '''INSERT INTO apis (collection_id, name, method, url, created_at, updated_at)
      //  VALUES (?, ?, ?, ?, ?, ?)''';

      final res = await databaseService?.executeQuery(
        sqlQuery: query,
        arguments: [
          event.id, // collection id
          // 'Get Users', // name
          // 'GET', // method
          // 'https://example.com/users', // url
          // DateTime.now().toIso8601String(), // created_at
          // DateTime.now().toIso8601String(), // updated_at
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
}
