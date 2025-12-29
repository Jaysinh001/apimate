import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repository/variable_repo/variable_repo.dart';

part 'variable_state.dart';
part 'variable_event.dart';

class CollectionVariablesBloc
    extends Bloc<CollectionVariablesEvent, CollectionVariablesState> {
  final CollectionVariablesRepo _repo;

  CollectionVariablesBloc({CollectionVariablesRepo? repo})
      : _repo = repo ?? CollectionVariablesRepo(),
        super(const CollectionVariablesState()) {
    on<LoadCollectionVariables>(handleLoadCollectionVariables);
    on<AddCollectionVariable>(handleAddCollectionVariable);
    on<UpdateCollectionVariable>(handleUpdateCollectionVariable);
    on<ToggleCollectionVariable>(handleToggleCollectionVariable);
  }

  /// ===============================
  /// LOAD VARIABLES
  /// ===============================
  FutureOr<void> handleLoadCollectionVariables(
    LoadCollectionVariables event,
    Emitter<CollectionVariablesState> emit,
  ) async {
    try {
      emit(state.copyWith(status: CollectionVariablesStatus.loading));

      final variables =
          await _repo.getVariables(collectionId: event.collectionID);

      emit(
        state.copyWith(
          status: CollectionVariablesStatus.loaded,
          variables: variables,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CollectionVariablesStatus.error,
          message: e.toString(),
        ),
      );
    }
  }

  /// ===============================
  /// ADD VARIABLE
  /// ===============================
  FutureOr<void> handleAddCollectionVariable(
    AddCollectionVariable event,
    Emitter<CollectionVariablesState> emit,
  ) async {
    try {
      await _repo.addVariable(
        collectionId: event.collectionID,
        key: event.key,
        value: event.value,
      );

      // Reload variables
      final variables =
          await _repo.getVariables(collectionId: event.collectionID);

      emit(
        state.copyWith(
          status: CollectionVariablesStatus.loaded,
          variables: variables,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CollectionVariablesStatus.error,
          message: e.toString(),
        ),
      );
    }
  }

  /// ===============================
  /// UPDATE VARIABLE VALUE
  /// ===============================
  FutureOr<void> handleUpdateCollectionVariable(
    UpdateCollectionVariable event,
    Emitter<CollectionVariablesState> emit,
  ) async {
    try {
      await _repo.updateVariableValue(
        variableId: event.variableID,
        value: event.value,
      );

      final currentCollectionId =
          state.variables.isNotEmpty ? state.variables.first.collectionId : null;

      if (currentCollectionId != null) {
        final variables =
            await _repo.getVariables(collectionId: currentCollectionId);

        emit(
          state.copyWith(
            status: CollectionVariablesStatus.loaded,
            variables: variables,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: CollectionVariablesStatus.error,
          message: e.toString(),
        ),
      );
    }
  }

  /// ===============================
  /// TOGGLE VARIABLE
  /// ===============================
  FutureOr<void> handleToggleCollectionVariable(
    ToggleCollectionVariable event,
    Emitter<CollectionVariablesState> emit,
  ) async {
    try {
      await _repo.toggleVariable(
        variableId: event.variableID,
        isActive: event.isActive,
      );

      final currentCollectionId =
          state.variables.isNotEmpty ? state.variables.first.collectionId : null;

      if (currentCollectionId != null) {
        final variables =
            await _repo.getVariables(collectionId: currentCollectionId);

        emit(
          state.copyWith(
            status: CollectionVariablesStatus.loaded,
            variables: variables,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: CollectionVariablesStatus.error,
          message: e.toString(),
        ),
      );
    }
  }
}