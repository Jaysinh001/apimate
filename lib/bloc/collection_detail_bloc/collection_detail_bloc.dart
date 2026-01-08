import 'dart:async';

import 'package:apimate/domain/repository/collection_detail/collection_detail_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/model/collection_detail_model/collection_explorer_node.dart';
part 'collection_detail_state.dart';
part 'collection_detail_event.dart';

class CollectionDetailBloc
    extends Bloc<CollectionDetailEvent, CollectionDetailState> {
  final CollectionDetailRepo _repo = CollectionDetailRepo();
  CollectionDetailBloc() : super(const CollectionDetailState()) {
    on<LoadCollectionDetails>(handleLoadCollectionDetails);
    on<AddFolder>(handleAddFolder);
    on<EditFolder>(handleEditFolder);
    on<DeleteFolder>(handleDeleteFolder);
    on<AddRequest>(handleAddRequest);
    on<EditRequest>(handleEditRequest);
    on<DeleteRequest>(handleDeleteRequest);
  }

  Future<void> handleLoadCollectionDetails(
    LoadCollectionDetails event,
    Emitter<CollectionDetailState> emit,
  ) async {
    try {
      emit(state.copyWith(status: CollectionDetailStatus.loading));

      final explorerTree = await CollectionDetailRepo()
          .getCollectionExplorerTree(collectionId: event.collectionID);

      emit(
        state.copyWith(
          status: CollectionDetailStatus.loaded,
          explorerTree: explorerTree,
        ),
      );
    } catch (e) {}
  }

  Future<void> handleAddFolder(
    AddFolder event,
    Emitter<CollectionDetailState> emit,
  ) async {
    await CollectionDetailRepo().createFolder(
      collectionId: event.collectionId,
      parentFolderId: event.parentFolderId,
      name: event.name,
    );

    final updatedTree = await CollectionDetailRepo().getCollectionExplorerTree(
      collectionId: event.collectionId,
    );

    emit(
      state.copyWith(
        explorerTree: updatedTree,
        status: CollectionDetailStatus.loaded,
      ),
    );
  }

  FutureOr<void> handleEditFolder(
    EditFolder event,
    Emitter<CollectionDetailState> emit,
  ) async {
    await _repo.updateFolder(folderId: event.folderId, name: event.newName);
    final tree = await _repo.getCollectionExplorerTree(
      collectionId: event.collectionID,
    );
    emit(
      state.copyWith(
        explorerTree: tree,
        status: CollectionDetailStatus.loaded,
      ),
    );
  }

  FutureOr<void> handleDeleteFolder(
    DeleteFolder event,
    Emitter<CollectionDetailState> emit,
  ) async {
    await _repo.deleteFolder(event.folderId);
    final tree = await _repo.getCollectionExplorerTree(
      collectionId: event.collectionID,
    );
    emit(
      state.copyWith(
        explorerTree: tree,
        status: CollectionDetailStatus.loaded,
      ),
    );
  }

  Future<void> handleAddRequest(
    AddRequest event,
    Emitter<CollectionDetailState> emit,
  ) async {
    await CollectionDetailRepo().createRequest(
      collectionId: event.collectionId,
      folderId: event.folderId,
      name: event.name,
      method: event.method,
      url: event.url,
    );

    final updatedTree = await CollectionDetailRepo().getCollectionExplorerTree(
      collectionId: event.collectionId,
    );

    emit(
      state.copyWith(
        explorerTree: updatedTree,
        status: CollectionDetailStatus.loaded,
      ),
    );
  }

  FutureOr<void> handleEditRequest(
    EditRequest event,
    Emitter<CollectionDetailState> emit,
  ) async {
    await _repo.updateRequest(
      requestId: event.requestId,
      name: event.name,
      method: event.method,
      url: event.url,
    );
    final tree = await _repo.getCollectionExplorerTree(
      collectionId: event.collectionID,
    );
    emit(
      state.copyWith(
        explorerTree: tree,
        status: CollectionDetailStatus.loaded,
      ),
    );
  }

  FutureOr<void> handleDeleteRequest(
    DeleteRequest event,
    Emitter<CollectionDetailState> emit,
  ) async {
    await _repo.deleteRequest(event.requestId);
    final tree = await _repo.getCollectionExplorerTree(
      collectionId: event.collectionID,
    );
    emit(
      state.copyWith(
        explorerTree: tree,
        status: CollectionDetailStatus.loaded,
      ),
    );
  }
}
