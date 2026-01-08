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

// ===============================
// FOLDER
// ===============================
class AddFolder extends CollectionDetailEvent {
  final int collectionId;
  final int? parentFolderId;
  final String name;

  const AddFolder({
    required this.collectionId,
    required this.parentFolderId,
    required this.name,
  });

  @override
  List<Object?> get props => [collectionId, parentFolderId, name];
}

class EditFolder extends CollectionDetailEvent {
  final int folderId;
  final String newName;
  final int collectionID;

  const EditFolder({required this.folderId, required this.newName, required this.collectionID});

  @override
  List<Object?> get props => [folderId, newName , collectionID];
}

class DeleteFolder extends CollectionDetailEvent {
  final int folderId;
  final int collectionID;


  const DeleteFolder({required this.folderId, required this.collectionID});

  @override
  List<Object?> get props => [folderId , collectionID];
}

// ===============================
// REQUEST
// ===============================
class AddRequest extends CollectionDetailEvent {
  final int collectionId;
  final int? folderId;
  final String name;
  final String method;
  final String url;

  const AddRequest({
    required this.collectionId,
    required this.folderId,
    required this.name,
    required this.method,
    required this.url,
  });

  @override
  List<Object?> get props => [collectionId, folderId, name, method, url];
}

class EditRequest extends CollectionDetailEvent {
  final int requestId;
  final String name;
  final String method;
  final String url;
  final int collectionID;


  const EditRequest({
    required this.requestId,
    required this.name,
    required this.method,
    required this.url, required this.collectionID,
  });

  @override
  List<Object?> get props => [requestId, name, method, url, collectionID];
}

class DeleteRequest extends CollectionDetailEvent {
  final int requestId;
  final int collectionID;


  const DeleteRequest({required this.requestId, required this.collectionID});

  @override
  List<Object?> get props => [requestId, collectionID];
}
