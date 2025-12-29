
part of 'collection_detail_bloc.dart';

class CollectionDetailEvent extends Equatable {
  const CollectionDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadCollectionDetails extends CollectionDetailEvent {
  final int collectionID;
  const LoadCollectionDetails({required this.collectionID});

  @override
  List<Object?> get props => [collectionID];
}
