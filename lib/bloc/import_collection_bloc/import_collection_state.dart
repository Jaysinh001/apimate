part of 'import_collection_bloc.dart';

enum ImportCollectionScreenStatus { initial, loading, preview, error }

class ImportCollectionState extends Equatable {
  final ImportCollectionScreenStatus status;
  final List<ImportPreviewNode> previewTree;
  final int importFolderCount;
  final int importRequestCount;
  final PostmanInfo postmanInfo;
  final Map<String, int> importMethodCount;

  final String? message;

  const ImportCollectionState({
    this.status = ImportCollectionScreenStatus.initial,
    this.importFolderCount = 0,
    this.importRequestCount = 0,
    this.importMethodCount = const {},
    this.previewTree = const [],
    this.postmanInfo = const PostmanInfo(description: '' , name: '' , postmanId: '', version: '', schema: '' ),
    this.message,
  });

  ImportCollectionState copyWith({
    ImportCollectionScreenStatus? status,
    int? importFolderCount,
    int? importRequestCount,
    Map<String, int>? importMethodCount,
    List<ImportPreviewNode>? previewTree,
    PostmanInfo? postmanInfo,
    String? message,
  }) {
    return ImportCollectionState(
      status: status ?? this.status,
      importFolderCount: importFolderCount ?? this.importFolderCount,
      importRequestCount: importRequestCount ?? this.importRequestCount,
      importMethodCount: importMethodCount ?? this.importMethodCount,
      previewTree: previewTree ?? this.previewTree,
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
    postmanInfo,
    message,
  ];
}
