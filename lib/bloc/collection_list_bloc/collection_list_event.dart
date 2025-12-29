part of 'collection_list_bloc.dart';



class CollectionListEvent extends Equatable {
  const CollectionListEvent();

  @override
  List<Object?> get props => [];
}

class GetCollectionsFromLocalDB extends CollectionListEvent {
  const GetCollectionsFromLocalDB();

  @override
  List<Object?> get props => [];
}

class CreateCollection extends CollectionListEvent {
  final String name;
  const CreateCollection({required this.name});

  @override
  List<Object?> get props => [name];
}

class DeleteCollection extends CollectionListEvent {
  final int id;
  const DeleteCollection({required this.id});

  @override
  List<Object?> get props => [id];
}


