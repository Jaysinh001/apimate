import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/utility/utility.dart';
import '../../domain/model/request_client_model/request_client_data_model.dart';
import '../../domain/model/request_client_model/request_draft_model.dart';
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

  /// Immutable DB-loaded metadata
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

    on<AddHeader>(_handleAddHeader);
    on<UpdateHeader>(_handleUpdateHeader);
    on<RemoveHeader>(_handleRemoveHeader);

    on<AddQueryParam>(_handleAddQueryParam);
    on<UpdateQueryParam>(_handleUpdateQueryParam);
    on<RemoveQueryParam>(_handleRemoveQueryParam);

    on<UpdateRequestBody>(_handleUpdateRequestBody);
    on<UpdateResolvedUrl>(_handleUpdateResolvedUrl);

    on<SaveResponse>(_handleSaveResponse);

    on<SaveRequestDraft>(_handleSaveRequestDraft);
  }

  // ============================================================
  // LOAD REQUEST (DB → Draft)
  // ============================================================
  Future<void> _handleLoadRequestDetails(
    LoadRequestDetails event,
    Emitter<RequestClientState> emit,
  ) async {
    try {
      emit(state.copyWith(status: RequestClientStatus.loading));

      _requestData = await _repo.loadRequest(event.requestId);

      final draft = RequestDraft.fromLoadedData(
        method: _requestData!.method,
        rawUrl: _requestData!.rawUrl,
        headers: _requestData!.headers,
        queryParams: _requestData!.queryParams,
        body: _requestData!.body?.content,
        contentType: _requestData!.body?.contentType,
      );

      final resolution = _resolveUrl(draft);

      emit(
        state.copyWith(
          status: RequestClientStatus.ready,
          requestId: _requestData!.requestId,
          draft: draft,
          savedDraft: draft, // ✅ baseline snapshot
          hasUnsavedChanges: false,
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

  // ============================================================
  // REFRESH VARIABLE RESOLUTION (no mutation)
  // ============================================================
  void _handleRefreshResolvedRequest(
    RefreshResolvedRequest event,
    Emitter<RequestClientState> emit,
  ) {
    if (state.draft == null) return;

    final resolution = _resolveUrl(state.draft!);

    emit(
      state.copyWith(
        resolvedUrl: resolution.resolvedValue,
        variableWarnings: resolution.warnings,
      ),
    );
  }

  // ============================================================
  // SEND REQUEST (Draft → Execute)
  // ============================================================
  Future<void> _handleSendRequest(
    SendRequest event,
    Emitter<RequestClientState> emit,
  ) async {
    if (state.draft == null || _requestData == null) return;

    emit(state.copyWith(status: RequestClientStatus.sending));

    try {
      final resolution = _resolveUrl(state.draft!);

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
        method: state.draft!.method,
        url: resolution.resolvedValue,
        headers: state.draft!.headers,
        queryParams: state.draft!.queryParams,
        body: state.draft!.body,
        contentType: state.draft!.contentType,
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

  // ============================================================
  // VARIABLE RESOLUTION (always via Draft)
  // ============================================================
  VariableResolutionResult _resolveUrl(RequestDraft draft) {
    return VariableResolver.resolve(
      draft.rawUrl,
      sources: [
        VariableSource(
          values: _requestData!.collectionVariables,
          inactiveKeys: _requestData!.inactiveCollectionVariables,
        ),
        // Folder variables (future)
        // Environment variables (future)
      ],
    );
  }

  // ============================================================
  // RESOLVED URL EDIT EVENTS
  // ============================================================
  void _handleUpdateResolvedUrl(
    UpdateResolvedUrl event,
    Emitter<RequestClientState> emit,
  ) {
    if (state.draft == null) return;

    _updateDraft(emit, state.draft!.copyWith(rawUrl: event.url));
  }

  // ============================================================
  // HEADER EDIT EVENTS
  // ============================================================
  void _handleAddHeader(AddHeader event, Emitter<RequestClientState> emit) {
    if (state.draft == null) return;

    final headers = Map<String, String>.from(state.draft!.headers)
      ..[event.key] = event.value;

    _updateDraft(emit, state.draft!.copyWith(headers: headers));
  }

  void _handleUpdateHeader(
    UpdateHeader event,
    Emitter<RequestClientState> emit,
  ) {
    if (state.draft == null) return;

    final headers = Map<String, String>.from(state.draft!.headers)
      ..[event.key] = event.value;

    _updateDraft(emit, state.draft!.copyWith(headers: headers));
  }

  void _handleRemoveHeader(
    RemoveHeader event,
    Emitter<RequestClientState> emit,
  ) {
    if (state.draft == null) return;

    final headers = Map<String, String>.from(state.draft!.headers)
      ..remove(event.key);

    _updateDraft(emit, state.draft!.copyWith(headers: headers));
  }

  // ============================================================
  // QUERY PARAM EDIT EVENTS
  // ============================================================
  void _handleAddQueryParam(
    AddQueryParam event,
    Emitter<RequestClientState> emit,
  ) {
    if (state.draft == null) return;

    final params = Map<String, String>.from(state.draft!.queryParams)
      ..[event.key] = event.value;

    _updateDraft(emit, state.draft!.copyWith(queryParams: params));
  }

  void _handleUpdateQueryParam(
    UpdateQueryParam event,
    Emitter<RequestClientState> emit,
  ) {
    if (state.draft == null) return;

    final params = Map<String, String>.from(state.draft!.queryParams)
      ..[event.key] = event.value;

    _updateDraft(emit, state.draft!.copyWith(queryParams: params));
  }

  void _handleRemoveQueryParam(
    RemoveQueryParam event,
    Emitter<RequestClientState> emit,
  ) {
    if (state.draft == null) return;

    final params = Map<String, String>.from(state.draft!.queryParams)
      ..remove(event.key);

    _updateDraft(emit, state.draft!.copyWith(queryParams: params));
  }

  // ============================================================
  // BODY EDIT EVENT
  // ============================================================
  void _handleUpdateRequestBody(
    UpdateRequestBody event,
    Emitter<RequestClientState> emit,
  ) {
    if (state.draft == null) return;

    _updateDraft(
      emit,
      state.draft!.copyWith(
        body: event.body,
        contentType: event.contentType ?? state.draft!.contentType,
      ),
    );
  }

  // ============================================================
  // CENTRAL DRAFT UPDATE + RE-RESOLVE
  // ============================================================
  void _updateDraft(
    Emitter<RequestClientState> emit,
    RequestDraft updatedDraft,
  ) {
    final resolution = _resolveUrl(updatedDraft);

    final hasChanges =
        state.savedDraft != null && updatedDraft != state.savedDraft;

    emit(
      state.copyWith(
        draft: updatedDraft,
        resolvedUrl: resolution.resolvedValue,
        variableWarnings: resolution.warnings,
        hasUnsavedChanges: hasChanges,
      ),
    );
  }

  void _handleSaveResponse(
    SaveResponse event,
    Emitter<RequestClientState> emit,
  ) {
    if (state.lastResponse == null) return;

    // TODO: Persist response via repository
    // repo.saveResponse(state.lastResponse!)

    // UX feedback handled in UI
  }

  Future<void> _handleSaveRequestDraft(
    SaveRequestDraft event,
    Emitter<RequestClientState> emit,
  ) async {
    if (state.draft == null || _requestData == null) return;

    try {
      emit(state.copyWith(status: RequestClientStatus.loading));

      await _repo.saveRequestDraft(
        requestId: _requestData!.requestId,
        draft: state.draft!,
      );

      emit(
        state.copyWith(
          status: RequestClientStatus.ready,
          savedDraft: state.draft, // ✅ reset baseline
          hasUnsavedChanges: false,
          message: 'Changes saved',
        ),
      );
    } catch (e) {
      Utility.showLog("_handleSaveRequestDraft : $e ");

      emit(
        state.copyWith(
          status: RequestClientStatus.error,
          message: 'Failed to save changes',
        ),
      );
    }
  }
}
