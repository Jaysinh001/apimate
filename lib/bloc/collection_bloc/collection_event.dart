part of 'collection_bloc.dart';

class CollectionEvent extends Equatable {
  const CollectionEvent();

  @override
  List<Object?> get props => [];
}

class GetCollectionsFromLocalDB extends CollectionEvent {
  const GetCollectionsFromLocalDB();

  @override
  List<Object?> get props => [];
}

class CreateCollection extends CollectionEvent {
  final String name;
  const CreateCollection({required this.name});

  @override
  List<Object?> get props => [name];
}

class DeleteCollection extends CollectionEvent {
  final int id;
  const DeleteCollection({required this.id});

  @override
  List<Object?> get props => [id];
}

class ImportCollectionFile extends CollectionEvent {
  const ImportCollectionFile();
}
