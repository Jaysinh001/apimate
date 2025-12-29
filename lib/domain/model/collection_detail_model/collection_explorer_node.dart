import 'package:equatable/equatable.dart';

enum ExplorerNodeType { folder, request }

class CollectionExplorerNode extends Equatable {
  /// Common
  final ExplorerNodeType type;
  final int id;                // DB id (folder_id or request_id)
  final String name;

  /// Folder-only
  final int? parentFolderId;
  final List<CollectionExplorerNode> children;

  /// Request-only
  final String? method;
  final String? url;

  const CollectionExplorerNode({
    required this.type,
    required this.id,
    required this.name,
    this.parentFolderId,
    this.children = const [],
    this.method,
    this.url,
  });

  bool get isFolder => type == ExplorerNodeType.folder;
  bool get isRequest => type == ExplorerNodeType.request;

  @override
  List<Object?> get props => [
        type,
        id,
        name,
        parentFolderId,
        children,
        method,
        url,
      ];
}
