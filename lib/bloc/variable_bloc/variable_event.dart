part of 'variable_bloc.dart';


abstract class CollectionVariablesEvent extends Equatable {
  const CollectionVariablesEvent();

  @override
  List<Object?> get props => [];
}

class LoadCollectionVariables extends CollectionVariablesEvent {
  final int collectionID;

  const LoadCollectionVariables({required this.collectionID});

  @override
  List<Object?> get props => [collectionID];
}

class AddCollectionVariable extends CollectionVariablesEvent {
  final int collectionID;
  final String key;
  final String value;

  const AddCollectionVariable({
    required this.collectionID,
    required this.key,
    required this.value,
  });

  @override
  List<Object?> get props => [collectionID, key, value];
}

class UpdateCollectionVariable extends CollectionVariablesEvent {
  final int variableID;
  final String value;

  const UpdateCollectionVariable({
    required this.variableID,
    required this.value,
  });

  @override
  List<Object?> get props => [variableID, value];
}

class ToggleCollectionVariable extends CollectionVariablesEvent {
  final int variableID;
  final bool isActive;

  const ToggleCollectionVariable({
    required this.variableID,
    required this.isActive,
  });

  @override
  List<Object?> get props => [variableID, isActive];
}
