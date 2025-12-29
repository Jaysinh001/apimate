part of 'collection_list_bloc.dart';

enum CollectionScreenStatus { initial, loading, success, error, created }

class CollectionListState extends Equatable {
  final CollectionScreenStatus collectionScreenStatus;
  final int importFolderCount;
  final int importRequestCount;
  final Map<String, int> importMethodCount;

  final List<CollectionListModel> collectionList;
  final String? message;

  const CollectionListState({
    this.collectionScreenStatus = CollectionScreenStatus.initial,
     this.importFolderCount = 0,
     this.importRequestCount = 0,
     this.importMethodCount = const {},
    this.collectionList = const [],
    this.message,
  });

  CollectionListState copyWith({
    CollectionScreenStatus? collectionScreenStatus,
    int? importFolderCount,
    int? importRequestCount,
    Map<String, int>? importMethodCount,
    List<CollectionListModel>? collectionList,
    String? message,
  }) => CollectionListState(
    collectionScreenStatus:
        collectionScreenStatus ?? this.collectionScreenStatus,
    collectionList: collectionList ?? this.collectionList,
    importFolderCount: importFolderCount ?? this.importFolderCount,
    importRequestCount: importRequestCount ?? this.importRequestCount,
    importMethodCount: importMethodCount ?? this.importMethodCount,
    message: message,
  );


  @override
  List<Object?> get props => [collectionScreenStatus, collectionList, importFolderCount , importFolderCount , importMethodCount,  message];
}



