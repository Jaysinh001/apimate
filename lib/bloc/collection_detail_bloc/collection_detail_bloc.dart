import 'dart:async';

import 'package:apimate/domain/repository/collection_detail/collection_detail_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/model/collection_detail_model/collection_explorer_node.dart';
part 'collection_detail_state.dart';
part 'collection_detail_event.dart';

class CollectionDetailBloc
    extends Bloc<CollectionDetailEvent, CollectionDetailState> {
  CollectionDetailBloc() : super(const CollectionDetailState()) {
    on<LoadCollectionDetails>(handleLoadCollectionDetails);
  }

  Future<void> handleLoadCollectionDetails(
    LoadCollectionDetails event,
    Emitter<CollectionDetailState> emit,
  ) async {
    try {
      emit(state.copyWith(status: CollectionDetailStatus.loading));

      final explorerTree = await CollectionDetailRepo().getCollectionExplorerTree(collectionId: event.collectionID);

      emit(state.copyWith(status: CollectionDetailStatus.loaded , explorerTree: explorerTree));



    } catch (e) {}
  }
}
