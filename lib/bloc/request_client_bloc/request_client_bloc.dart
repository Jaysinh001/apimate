import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/model/request_client_model/request_client_data_model.dart';
import '../../domain/model/request_client_model/request_execution_input.dart';
import '../../domain/model/request_client_model/request_response_model.dart';
import '../../domain/model/variable_resolution_engine_model/variable_resolution_engine_model.dart';
import '../../domain/repository/request_client/request_client_repo.dart';
import '../../domain/repository/request_client/request_execution_service.dart';
import '../../domain/repository/variable_repo/variable_resolver_engine.dart';

part 'request_client_event.dart';
part 'request_client_state.dart';

class RequestClientBloc extends Bloc<RequestClientEvent, RequestClientState> {
  final RequestClientRepo _repo;
  final RequestExecutionService _executor;

  RequestClientData? _requestData;

  RequestClientBloc({
    RequestClientRepo? repo,
    RequestExecutionService? executor,
  }) : _repo = repo ?? RequestClientRepo(),
       _executor = executor ?? RequestExecutionService(),
       super(const RequestClientState()) {
    on<LoadRequestDetails>(_handleLoadRequestDetails);
    on<RefreshResolvedRequest>(_handleRefreshResolvedRequest);
    on<SendRequest>(_handleSendRequest);
  }

  // ===============================
  // LOAD REQUEST
  // ===============================
  Future<void> _handleLoadRequestDetails(
    LoadRequestDetails event,
    Emitter<RequestClientState> emit,
  ) async {
    try {
      emit(state.copyWith(status: RequestClientStatus.loading));

      _requestData = await _repo.loadRequest(event.requestId);

      final resolution = _resolveUrl(_requestData!);

      emit(
        state.copyWith(
          status: RequestClientStatus.ready,
          requestId: _requestData!.requestId,
          method: _requestData!.method,
          rawUrl: _requestData!.rawUrl,
          resolvedUrl: resolution.resolvedValue,
          variableWarnings: resolution.warnings,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RequestClientStatus.error,
          message: e.toString(),
        ),
      );
    }
  }

  // ===============================
  // REFRESH VARIABLE RESOLUTION
  // ===============================
  Future<void> _handleRefreshResolvedRequest(
    RefreshResolvedRequest event,
    Emitter<RequestClientState> emit,
  ) async {
    if (_requestData == null) return;

    final resolution = _resolveUrl(_requestData!);

    emit(
      state.copyWith(
        resolvedUrl: resolution.resolvedValue,
        variableWarnings: resolution.warnings,
      ),
    );
  }

  // ===============================
  // SEND REQUEST
  // ===============================
  Future<void> _handleSendRequest(
    SendRequest event,
    Emitter<RequestClientState> emit,
  ) async {
    if (_requestData == null) return;

    emit(state.copyWith(status: RequestClientStatus.sending));

    try {
      // Resolve URL again (latest variables)
      final resolution = _resolveUrl(_requestData!);

      if (resolution.hasErrors) {
        emit(
          state.copyWith(
            status: RequestClientStatus.error,
            message: 'Variable resolution failed',
            variableWarnings: resolution.warnings,
          ),
        );
        return;
      }

      final input = RequestExecutionInput(
        method: _requestData!.method,
        url: resolution.resolvedValue,
        headers: _requestData!.headers,
        queryParams: _requestData!.queryParams,
        body: _requestData!.body?.content,
        contentType: _requestData!.body?.contentType,
      );

      final response = await _executor.execute(
        requestId: _requestData!.requestId,
        input: input,
      );

      emit(
        state.copyWith(
          status:
              response.isError
                  ? RequestClientStatus.error
                  : RequestClientStatus.success,
          lastResponse: response,
          message: response.isError ? response.errorMessage : null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RequestClientStatus.error,
          message: e.toString(),
        ),
      );
    }
  }

  // ===============================
  // VARIABLE RESOLUTION (URL only for now)
  // ===============================
  VariableResolutionResult _resolveUrl(RequestClientData data) {
    return VariableResolver.resolve(
      data.rawUrl,
      sources: [
        // Folder variables (future)
        VariableSource(
          values: data.collectionVariables,
          inactiveKeys: data.inactiveCollectionVariables,
        ),
        // Environment variables (future)
      ],
    );
  }
}
