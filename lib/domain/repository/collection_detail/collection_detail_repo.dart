
import '../../../data/services/database_service.dart';
import '../../model/collection_detail_model/collection_explorer_node.dart';

class CollectionDetailRepo {
  final DatabaseService _dbService = DatabaseService.instance;

  /// Public API used by Bloc
  Future<List<CollectionExplorerNode>> getCollectionExplorerTree({
    required int collectionId,
  }) async {
    final db = await _dbService.database;

    // 1️⃣ Load folders
    final List<Map<String, dynamic>> folderRows = await db.query(
      'folders',
      where: 'collection_id = ? AND is_deleted = 0',
      whereArgs: [collectionId],
      orderBy: 'order_index ASC',
    );

    // 2️⃣ Load requests
    final List<Map<String, dynamic>> requestRows = await db.query(
      'requests',
      where: 'collection_id = ? AND is_deleted = 0',
      whereArgs: [collectionId],
      orderBy: 'order_index ASC',
    );

    // 3️⃣ Build node buckets by parentFolderId
    final Map<int?, List<CollectionExplorerNode>> nodeBuckets = {};

    void addNode(int? parentId, CollectionExplorerNode node) {
      nodeBuckets.putIfAbsent(parentId, () => []);
      nodeBuckets[parentId]!.add(node);
    }

    // 4️⃣ Convert folders to nodes
    for (final row in folderRows) {
      final node = CollectionExplorerNode(
        type: ExplorerNodeType.folder,
        id: row['id'] as int,
        name: row['name'] as String,
        parentFolderId: row['parent_folder_id'] as int?,
        children: const [],
      );

      addNode(row['parent_folder_id'] as int?, node);
    }

    // 5️⃣ Convert requests to nodes
    for (final row in requestRows) {
      final node = CollectionExplorerNode(
        type: ExplorerNodeType.request,
        id: row['id'] as int,
        name: row['name'] as String,
        method: row['method'] as String?,
        url: row['url'] as String?,
        parentFolderId: row['folder_id'] as int?,
        children: const [],
      );

      addNode(row['folder_id'] as int?, node);
    }

    // 6️⃣ Attach children recursively
    List<CollectionExplorerNode> buildTree(int? parentId) {
      final nodes = nodeBuckets[parentId] ?? [];

      return nodes.map((node) {
        if (node.isFolder) {
          return CollectionExplorerNode(
            type: ExplorerNodeType.folder,
            id: node.id,
            name: node.name,
            parentFolderId: node.parentFolderId,
            children: buildTree(node.id),
          );
        }
        return node;
      }).toList();
    }

    // 7️⃣ Root nodes (parentFolderId == null)
    return buildTree(null);
  }
}
