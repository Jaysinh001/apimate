import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

import '../../config/utility/utility.dart';
import '../../domain/model/get_api_list_model.dart';
import '../../domain/model/headers_list_model.dart';
import '../../domain/model/params_list_model.dart';
import '../../main.dart';

part 'api_request_event.dart';
part 'api_request_state.dart';

class ApiRequestBloc extends Bloc<ApiRequestEvent, ApiRequestState> {
  ApiRequestBloc() : super(const ApiRequestState()) {
    on<ToggleRequestType>(handleToggleRequestType);
    on<ApiTextChanged>(handleApiTextChanged);
    // >>>>>>>>> Params Handlers <<<<<<<<<<
    on<GetApiParams>(handleGetApiParams);
    on<AddParams>(handleAddParams);
    on<DeleteParams>(handleDeleteParams);
    on<UpdateParams>(handleUpdateParams);

    // >>>>>>>>> Authorization Handlers <<<<<<<<<<
    on<AuthChanged>(handleAuthChanged);

    // >>>>>>>>> Headers Handlers <<<<<<<<<<
    on<GetApiHeaders>(handleGetApiHeaders);
    on<DeleteHeader>(handleDeleteHeader);
    on<AddHeader>(handleAddHeader);
    on<BodyChanged>(handleBodyChanged);
    on<SendApiRequest>(handleSendApiRequest);
    on<SelectAuthType>(handleSelectAuthType);
    on<BasicAuthUsernameChanged>(handleBasicAuthUsernameChanged);
    on<BasicAuthPasswordChanged>(handleBasicAuthPasswordChanged);
    on<BearerTokenChanged>(handleBearerTokenChanged);
    on<LoadSelectedApiData>(handleLoadSelectedApiData);
    on<SaveApiToLocalDB>(handleSaveApiToLocalDB);
  }

  FutureOr<void> handleToggleRequestType(
    ToggleRequestType event,
    Emitter<ApiRequestState> emit,
  ) {
    emit(
      state.copyWith(
        apiRequestStatus: ApiRequestStatus.initial,
        isGetRequest: event.isGetRequest,
      ),
    );
  }

  FutureOr<void> handleApiTextChanged(
    ApiTextChanged event,
    Emitter<ApiRequestState> emit,
  ) {
    emit(
      state.copyWith(
        apiRequestStatus: ApiRequestStatus.initial,
        api: event.api,
      ),
    );
  }

  FutureOr<void> handleGetApiParams(
    GetApiParams event,
    Emitter<ApiRequestState> emit,
  ) async {
    emit(state.copyWith(apiRequestStatus: ApiRequestStatus.loading));

    try {
      final query = '''SELECT * FROM query_params WHERE api_id = ?''';

      final res = await databaseService?.executeQuery(
        sqlQuery: query,
        arguments: [
          event.apiID, // api id
        ],
      );

      Utility.showLog("handleGetApiParams ::: $res");

      final paramsList = paramsListModelFromJson(jsonEncode(res));

      Utility.showLog("headersListModelFromJson ::: $paramsList");

      emit(
        state.copyWith(
          apiRequestStatus: ApiRequestStatus.success,
          params: paramsList,
        ),
      );
    } catch (e) {
      Utility.showLog("handleGetApiParams Exception ::: $e");

      emit(
        state.copyWith(
          apiRequestStatus: ApiRequestStatus.error,
          message: "Something went wrong!",
        ),
      );
    }
  }

  FutureOr<void> handleAddParams(
    AddParams event,
    Emitter<ApiRequestState> emit,
  ) async {
    emit(state.copyWith(apiRequestStatus: ApiRequestStatus.loading));

    try {
      String query =
          '''INSERT INTO query_params (api_id, key, value, created_at, updated_at) VALUES (?, ?, ?, ?, ?)''';

      Utility.showLog("message1");

      final res = await databaseService?.executeQuery(
        sqlQuery: query,
        arguments: [
          event.apiID,
          event.key,
          event.value,
          DateTime.now().toIso8601String(),
          DateTime.now().toIso8601String(),
        ],
      );

      Utility.showLog("message2 : $res");

      if (res is int) {
        Utility.showLog("message3");

        add(GetApiParams(apiID: event.apiID));

        emit(state.copyWith(apiRequestStatus: ApiRequestStatus.created));
      } else {
        Utility.showLog("message4");

        emit(
          state.copyWith(
            apiRequestStatus: ApiRequestStatus.error,
            message: "failed to add header",
          ),
        );
      }
    } catch (e) {
      Utility.showLog("handleAddHeader Exception ::: $e");

      emit(
        state.copyWith(
          apiRequestStatus: ApiRequestStatus.error,
          message: "Something went wrong!",
        ),
      );
    }
  }

  FutureOr<void> handleUpdateParams(
    UpdateParams event,
    Emitter<ApiRequestState> emit,
  ) async {
    emit(state.copyWith(apiRequestStatus: ApiRequestStatus.loading));

    try {
      final query =
          '''UPDATE query_params SET key = ?, value = ?, is_active = ?, updated_at = ? WHERE id = ?''';

      final res = await databaseService?.executeQuery(
        sqlQuery: query,
        arguments: [
          event.keyName,
          event.value,
          (event.isActive ?? false) ? 1 : 0,
          DateTime.now().toIso8601String(),
          event.id,
        ],
      );

      Utility.showLog("handleUpdateParams :: $res");

      if (res == 0) {
        emit(
          state.copyWith(
            apiRequestStatus: ApiRequestStatus.error,
            message: "Failed to update this Parameter",
          ),
        );
      } else if (res > 1) {
        emit(
          state.copyWith(
            apiRequestStatus: ApiRequestStatus.error,
            message: "Oops! multiple Parameters updated!",
          ),
        );
      } else {
        add(GetApiParams(apiID: event.id));
      }
    } catch (e) {
      emit(
        state.copyWith(
          apiRequestStatus: ApiRequestStatus.error,
          message: "Oops! Something went wrong",
        ),
      );
    }
  }

  FutureOr<void> handleDeleteParams(
    DeleteParams event,
    Emitter<ApiRequestState> emit,
  ) async {
    emit(state.copyWith(apiRequestStatus: ApiRequestStatus.loading));

    try {
      String query = '''DELETE FROM query_params WHERE ID = ?''';

      final res = await databaseService?.executeQuery(
        sqlQuery: query,
        arguments: [event.id],
      );

      Utility.showLog("handleDeleteParams response ::: $res");

      if (res is int) {
        state.params.removeWhere((element) => element.id == event.id);

        emit(state.copyWith(apiRequestStatus: ApiRequestStatus.initial));
      } else {
        emit(
          state.copyWith(
            apiRequestStatus: ApiRequestStatus.error,
            message: "failed to remove parameter",
          ),
        );
      }
    } catch (e) {
      Utility.showLog("handleDeleteParams Exception ::: $e");

      emit(
        state.copyWith(
          apiRequestStatus: ApiRequestStatus.error,
          message: "Something went wrong!",
        ),
      );
    }
  }

  // >>>>>>>>>>>>>>>>> Authorization Handlers <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  FutureOr<void> handleAuthChanged(
    AuthChanged event,
    Emitter<ApiRequestState> emit,
  ) {
    emit(
      state.copyWith(
        apiRequestStatus: ApiRequestStatus.initial,
        auth: event.auth,
      ),
    );
  }

  FutureOr<void> handleGetApiHeaders(
    GetApiHeaders event,
    Emitter<ApiRequestState> emit,
  ) async {
    emit(state.copyWith(apiRequestStatus: ApiRequestStatus.loading));

    try {
      final query = '''SELECT * FROM headers WHERE api_id = ?''';

      final res = await databaseService?.executeQuery(
        sqlQuery: query,
        arguments: [
          event.apiID, // api id
        ],
      );

      Utility.showLog("handleGetApiHeaders ::: $res");

      final headersList = headersListModelFromJson(jsonEncode(res));

      Utility.showLog("headersListModelFromJson ::: $headersList");

      emit(
        state.copyWith(
          apiRequestStatus: ApiRequestStatus.success,
          headers: headersList,
        ),
      );
    } catch (e) {
      Utility.showLog("handleGetApiHeaders Exception ::: $e");

      emit(
        state.copyWith(
          apiRequestStatus: ApiRequestStatus.error,
          message: "Something went wrong!",
        ),
      );
    }
  }

  FutureOr<void> handleAddHeader(
    AddHeader event,
    Emitter<ApiRequestState> emit,
  ) async {
    emit(state.copyWith(apiRequestStatus: ApiRequestStatus.loading));

    try {
      String query =
          '''INSERT INTO headers (api_id, key, value, created_at, updated_at) VALUES (?, ?, ?, ?, ?)''';

      final res = await databaseService?.executeQuery(
        sqlQuery: query,
        arguments: [
          event.apiID,
          event.key,
          event.value,
          DateTime.now().toIso8601String(),
          DateTime.now().toIso8601String(),
        ],
      );

      if (res is int) {
        add(GetApiHeaders(apiID: event.apiID));

        emit(state.copyWith(apiRequestStatus: ApiRequestStatus.created));
      } else {
        emit(
          state.copyWith(
            apiRequestStatus: ApiRequestStatus.error,
            message: "failed to add header",
          ),
        );
      }
    } catch (e) {
      Utility.showLog("handleAddHeader Exception ::: $e");

      emit(
        state.copyWith(
          apiRequestStatus: ApiRequestStatus.error,
          message: "Something went wrong!",
        ),
      );
    }
  }

  FutureOr<void> handleDeleteHeader(
    DeleteHeader event,
    Emitter<ApiRequestState> emit,
  ) async {
    emit(state.copyWith(apiRequestStatus: ApiRequestStatus.loading));

    try {
      String query = '''DELETE FROM headers WHERE ID = ?''';

      final res = await databaseService?.executeQuery(
        sqlQuery: query,
        arguments: [event.id],
      );

      Utility.showLog("handleDeleteHeader response ::: $res");

      if (res is int) {
        state.headers.removeWhere((element) => element.id == event.id);

        emit(state.copyWith(apiRequestStatus: ApiRequestStatus.initial));
      } else {
        emit(
          state.copyWith(
            apiRequestStatus: ApiRequestStatus.error,
            message: "failed to remove header",
          ),
        );
      }
    } catch (e) {
      Utility.showLog("handleDeleteHeader Exception ::: $e");

      emit(
        state.copyWith(
          apiRequestStatus: ApiRequestStatus.error,
          message: "Something went wrong!",
        ),
      );
    }
  }

  FutureOr<void> handleBodyChanged(
    BodyChanged event,
    Emitter<ApiRequestState> emit,
  ) {
    emit(
      state.copyWith(
        apiRequestStatus: ApiRequestStatus.initial,
        payload: event.body,
      ),
    );
  }

  FutureOr<void> handleSendApiRequest(
    SendApiRequest event,
    Emitter<ApiRequestState> emit,
  ) async {
    emit(state.copyWith(apiRequestStatus: ApiRequestStatus.sendingRequest));

    try {
      Utility.showLog('handleSendApiRequest called');

      // adding active params to URI
      String url = '';

      // Removing deactivated parameters (unchecked params) from url
      List<ParamsListModel> tempList = state.params;

      tempList.removeWhere((element) => element.isActive == 0);

      // adding active parameters (checked params) to url
      for (var i = 0; i < tempList.length; i++) {
        if (i == 0) {
          url += '?${tempList[i].key ?? ''}=${tempList[i].value ?? ''}';
        } else {
          url += '&${tempList[i].key ?? ''}=${tempList[i].value ?? ''}';
        }

        Utility.showLog("URL :: $url");
      }

      url = state.api + url;

      var uri = Uri.parse(url.trim());

      Utility.showLog("URI :: ${uri.path}");

      Map<String, String> headers = {
        'Connection': 'keep-alive',
        'Accept': '*/*',
      };
      dynamic payload;

      Utility.showLog('API : ${state.api}');

      // if (state.headers.isNotEmpty) {
      //   headers = jsonDecode(state.headers);
      // }

      if (state.payload.isNotEmpty) {
        payload = state.payload;
      }

      // adding authorization in headers
      if (generateAuthToken() != null && state.selectedAuthType != 'No Auth') {
        headers.addAll({'Authorization': generateAuthToken() ?? ''});
      }

      Utility.showLog('headers : $headers');

      Utility.showLog('payload : $payload');

      late http.Response res;

      if (state.isGetRequest) {
        res = await http.get(uri, headers: headers);
      } else {
        res = await http.post(uri, body: payload, headers: headers);
      }
      Utility.showLog('Response : $res');
      Utility.showLog('Response status: ${res.statusCode}');
      Utility.showLog('Response body: ${res.body}');

      emit(
        state.copyWith(
          apiRequestStatus: ApiRequestStatus.requestSuccess,
          response: res,
        ),
      );
    } catch (e) {
      Utility.showLog('Exception : $e');
      emit(
        state.copyWith(
          apiRequestStatus: ApiRequestStatus.requestFailed,
          message: "Something went wrong!",
        ),
      );
    }
  }

  FutureOr<void> handleSelectAuthType(
    SelectAuthType event,
    Emitter<ApiRequestState> emit,
  ) {
    emit(
      state.copyWith(
        apiRequestStatus: ApiRequestStatus.initial,
        selectedAuthType: event.authType,
      ),
    );
  }

  FutureOr<void> handleBasicAuthUsernameChanged(
    BasicAuthUsernameChanged event,
    Emitter<ApiRequestState> emit,
  ) {
    emit(
      state.copyWith(
        apiRequestStatus: ApiRequestStatus.initial,
        basicAuthUsername: event.username,
      ),
    );
  }

  FutureOr<void> handleBasicAuthPasswordChanged(
    BasicAuthPasswordChanged event,
    Emitter<ApiRequestState> emit,
  ) {
    emit(
      state.copyWith(
        apiRequestStatus: ApiRequestStatus.initial,
        basicAuthPassword: event.password,
      ),
    );
  }

  FutureOr<void> handleBearerTokenChanged(
    BearerTokenChanged event,
    Emitter<ApiRequestState> emit,
  ) {
    emit(
      state.copyWith(
        apiRequestStatus: ApiRequestStatus.initial,
        bearerToken: event.token,
      ),
    );
  }

  String? generateAuthToken() {
    if (state.selectedAuthType == 'Basic Auth') {
      return "Basic ${base64Encode(utf8.encode('${state.basicAuthUsername}:${state.basicAuthPassword}'))}";
    } else if (state.selectedAuthType == 'Bearer') {
      return 'Bearer ${state.bearerToken}';
    }

    return null;
  }

  FutureOr<void> handleLoadSelectedApiData(
    LoadSelectedApiData event,
    Emitter<ApiRequestState> emit,
  ) {
    String url = event.api?.url ?? state.api;
    emit(
      state.copyWith(
        api: url,
        isGetRequest:
            event.api != null
                ? event.api?.method == "GET"
                    ? true
                    : false
                : state.isGetRequest,
        apiName: event.name ?? state.apiName,
      ),
    );
  }

  FutureOr<void> handleSaveApiToLocalDB(
    SaveApiToLocalDB event,
    Emitter<ApiRequestState> emit,
  ) async {
    emit(state.copyWith(apiRequestStatus: ApiRequestStatus.loading));
    try {
      String query =
          '''UPDATE apis SET name = ?, method = ?, url = ?, updated_at = ? WHERE id = ?''';

      final res = await databaseService?.executeQuery(
        sqlQuery: query,
        arguments: [
          event.name ?? "Untitled Request",
          state.isGetRequest ? "GET" : "POST",
          state.api,
          DateTime.now().toIso8601String(),
          event.apiID,
        ],
      );

      Utility.showLog("handleSaveApiToLocalDB : $res");

      if (res == 0) {
        emit(
          state.copyWith(
            apiRequestStatus: ApiRequestStatus.error,
            message: "Failed to update this Parameter",
          ),
        );
      } else if (res > 1) {
        emit(
          state.copyWith(
            apiRequestStatus: ApiRequestStatus.error,
            message: "Oops! multiple apis updated!",
          ),
        );
      } else {
        emit(
          state.copyWith(
            apiRequestStatus: ApiRequestStatus.updated,
            message: "Api Saved",
          ),
        );
      }
    } catch (e) {
      state.copyWith(
        apiRequestStatus: ApiRequestStatus.error,
        message: "Something went wrong!",
      );
    }
  }
}
