import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

import '../../config/utility/utility.dart';
import '../../domain/model/get_api_list_model.dart';

part 'api_request_event.dart';
part 'api_request_state.dart';

class ApiRequestBloc extends Bloc<ApiRequestEvent, ApiRequestState> {
  ApiRequestBloc() : super(const ApiRequestState()) {
    on<ToggleRequestType>(handleToggleRequestType);
    on<ApiTextChanged>(handleApiTextChanged);
    on<ParamsChanged>(handleParamsChanged);
    on<AuthChanged>(handleAuthChanged);
    on<HeadersChanged>(handleHeadersChanged);
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

  FutureOr<void> handleParamsChanged(
    ParamsChanged event,
    Emitter<ApiRequestState> emit,
  ) {
    emit(
      state.copyWith(
        apiRequestStatus: ApiRequestStatus.initial,
        params: event.params,
      ),
    );
  }

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

  FutureOr<void> handleHeadersChanged(
    HeadersChanged event,
    Emitter<ApiRequestState> emit,
  ) {
    emit(
      state.copyWith(
        apiRequestStatus: ApiRequestStatus.initial,
        headers: event.header,
      ),
    );
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

      var url = Uri.parse(state.api.trim());
      Map<String, String> headers = {
        'Connection': 'keep-alive',
        'Accept': '*/*',
      };
      dynamic payload;

      Utility.showLog('API : ${state.api}');

      if (state.headers.isNotEmpty) {
        headers = jsonDecode(state.headers);
      }

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
        res = await http.get(url, headers: headers);
      } else {
        res = await http.post(url, body: payload, headers: headers);
      }
      Utility.showLog('Response status: ${res.statusCode}');
      Utility.showLog('Response body: ${res.body}');

      emit(
        state.copyWith(
          apiRequestStatus: ApiRequestStatus.success,
          response: res,
        ),
      );
    } catch (e) {
      Utility.showLog('Exception : $e');
      emit(
        state.copyWith(
          apiRequestStatus: ApiRequestStatus.error,
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
    emit(
      state.copyWith(
        api: event.api?.url ?? '',
        isGetRequest: event.api?.method == "GET" ? true : false,
      ),
    );
  }

  FutureOr<void> handleSaveApiToLocalDB(
    SaveApiToLocalDB event,
    Emitter<ApiRequestState> emit,
  ) {


    if (event.apiID != null) {
      
    }

    


  }
}
