
part of 'collection_detail_bloc.dart';


enum CollectionDetailStatus { initial, loading, loaded, updated , error}

class CollectionDetailState extends Equatable {
  final CollectionDetailStatus status;

  /// Root nodes of explorer tree
  final List<CollectionExplorerNode> explorerTree;

  final String? message;

  const CollectionDetailState({
    this.status = CollectionDetailStatus.initial,
    this.explorerTree = const [],
    this.message,
  });

  CollectionDetailState copyWith({
    CollectionDetailStatus? status,
    List<CollectionExplorerNode>? explorerTree,
    String? message,
  }) => CollectionDetailState(status: status ?? this.status,
  
    explorerTree : explorerTree ?? this.explorerTree,
  
   message: message);

  @override
  List<Object?> get props => [status,explorerTree, message];
}
