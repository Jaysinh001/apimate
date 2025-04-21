import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'api_request_event.dart';
part 'api_request_state.dart';

class ApiRequestBloc extends Bloc<ApiRequestEvent, ApiRequestState> {
  ApiRequestBloc() : super(const ApiRequestState()) {
    on<ToggleRequestType>(handleToggleRequestType);
  }

  FutureOr<void> handleToggleRequestType(
    ToggleRequestType event,
    Emitter<ApiRequestState> emit,
  ) {}
}
