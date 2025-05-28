part of 'api_list_bloc.dart';

class ApiListEvent extends Equatable {
  const ApiListEvent();

  @override
  List<Object?> get props => [];
}

class GetApiList extends ApiListEvent {
  final int id;
  const GetApiList({required this.id});

  @override
  List<Object?> get props => [id];
}

class CreateNewApi extends ApiListEvent {
  final int collectionID;
  const CreateNewApi({required this.collectionID});

  @override
  List<Object?> get props => [collectionID];
}
