part of 'import_collection_bloc.dart';

abstract class ImportCollectionEvent extends Equatable {
  const ImportCollectionEvent();

  @override
  List<Object?> get props => [];
}

class ImportCollectionFile extends ImportCollectionEvent {
  const ImportCollectionFile();

  @override
  List<Object?> get props => [];
}

class ImportDataToLocalStorage extends ImportCollectionEvent {
  const ImportDataToLocalStorage();

  @override
  List<Object?> get props => [];
}

class BuildImportPreview extends ImportCollectionEvent {
  // final PostmanCollection collection;

  // const BuildImportPreview({required this.collection});
  const BuildImportPreview();

  @override
  List<Object?> get props => [];
}
