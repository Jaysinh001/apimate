part of 'collection_bloc.dart';

enum CollectionScreenStatus { initial, loading, success, error, created }

class CollectionState extends Equatable {
  final CollectionScreenStatus collectionScreenStatus;
  final List<CollectionListModel> collectionList;
  final String? message;

  const CollectionState({
    this.collectionScreenStatus = CollectionScreenStatus.initial,
    this.collectionList = const [],
    this.message,
  });

  CollectionState copyWith({
    CollectionScreenStatus? collectionScreenStatus,
    List<CollectionListModel>? collectionList,
    String? message,
  }) => CollectionState(
    collectionScreenStatus:
        collectionScreenStatus ?? this.collectionScreenStatus,
    collectionList: collectionList ?? this.collectionList,
    message: message,
  );

  @override
  List<Object?> get props => [collectionScreenStatus, collectionList, message];
}
