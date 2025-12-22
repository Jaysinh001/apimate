part of 'collection_bloc.dart';

enum CollectionScreenStatus { initial, loading, success, error, created }

class CollectionState extends Equatable {
  final CollectionScreenStatus collectionScreenStatus;
  final int importFolderCount;
  final int importRequestCount;
  final Map<String, int> importMethodCount;

  final List<CollectionListModel> collectionList;
  final String? message;

  const CollectionState({
    this.collectionScreenStatus = CollectionScreenStatus.initial,
     this.importFolderCount = 0,
     this.importRequestCount = 0,
     this.importMethodCount = const {},
    this.collectionList = const [],
    this.message,
  });

  CollectionState copyWith({
    CollectionScreenStatus? collectionScreenStatus,
    int? importFolderCount,
    int? importRequestCount,
    Map<String, int>? importMethodCount,
    List<CollectionListModel>? collectionList,
    String? message,
  }) => CollectionState(
    collectionScreenStatus:
        collectionScreenStatus ?? this.collectionScreenStatus,
    collectionList: collectionList ?? this.collectionList,
    importFolderCount: importFolderCount ?? this.importFolderCount,
    importRequestCount: importRequestCount ?? this.importRequestCount,
    importMethodCount: importMethodCount ?? this.importMethodCount,
    message: message,
  );


  // GETTERS for IMPORT FEILDS
  int get folderCount => importFolderCount; 
  int get requestCount => importRequestCount; 
  Map<String, int> get methodCount => importMethodCount; 


  @override
  List<Object?> get props => [collectionScreenStatus, collectionList, message];
}



