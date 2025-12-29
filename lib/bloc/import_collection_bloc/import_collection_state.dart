part of 'import_collection_bloc.dart';

enum ImportCollectionScreenStatus { initial, loading, preview, error , imported }

class ImportCollectionState extends Equatable {
  final ImportCollectionScreenStatus status;
  final List<ImportPreviewNode> previewTree;
  final int importFolderCount;
  final int importRequestCount;
  final PostmanInfo postmanInfo;
  final PostmanCollection postmanCollection;
  final Map<String, int> importMethodCount;

  final String? message;

  const ImportCollectionState({
    this.status = ImportCollectionScreenStatus.initial,
    this.importFolderCount = 0,
    this.importRequestCount = 0,
    this.importMethodCount = const {},
    this.previewTree = const [],
    this.postmanCollection = const PostmanCollection(),
    this.postmanInfo = const PostmanInfo(description: '' , name: '' , postmanId: '', version: '', schema: '' ),
    this.message,
  });

  ImportCollectionState copyWith({
    ImportCollectionScreenStatus? status,
    int? importFolderCount,
    int? importRequestCount,
    Map<String, int>? importMethodCount,
    List<ImportPreviewNode>? previewTree,
    PostmanCollection? postmanCollection,
    PostmanInfo? postmanInfo,
    String? message,
  }) {
    return ImportCollectionState(
      status: status ?? this.status,
      importFolderCount: importFolderCount ?? this.importFolderCount,
      importRequestCount: importRequestCount ?? this.importRequestCount,
      importMethodCount: importMethodCount ?? this.importMethodCount,
      previewTree: previewTree ?? this.previewTree,
      postmanCollection: postmanCollection ?? this.postmanCollection,
      postmanInfo: postmanInfo ?? this.postmanInfo,
      message: message,
    );
  }

  @override
  List<Object?> get props => [
    status,
    importFolderCount,
    importFolderCount,
    importMethodCount,
    previewTree,
    postmanCollection,
    postmanInfo,
    message,
  ];
}
