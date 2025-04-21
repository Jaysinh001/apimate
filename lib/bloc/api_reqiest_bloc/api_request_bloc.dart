import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'api_request_event.dart';
part 'api_request_state.dart';

class ApiRequestBloc extends Bloc<ApiRequestEvent, ApiRequestState> {
  ApiRequestBloc() : super(const ApiRequestState()) {
    on<ToggleRequestType>(handleToggleRequestType);
    on<ApiTextChanged>(handleApiTextChanged);
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
}
