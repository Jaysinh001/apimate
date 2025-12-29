import 'package:equatable/equatable.dart';

class CollectionVariable extends Equatable {
  final int id;
  final int collectionId;
  final String key;
  final String? value;
  final bool isActive;

  const CollectionVariable({
    required this.id,
    required this.collectionId,
    required this.key,
    this.value,
    required this.isActive,
  });

  factory CollectionVariable.fromMap(Map<String, dynamic> map) {
    return CollectionVariable(
      id: map['id'] as int,
      collectionId: map['collection_id'] as int,
      key: map['key'] as String,
      value: map['value'] as String?,
      isActive: (map['is_active'] as int) == 1,
    );
  }

  CollectionVariable copyWith({
    String? value,
    bool? isActive,
  }) {
    return CollectionVariable(
      id: id,
      collectionId: collectionId,
      key: key,
      value: value ?? this.value,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [id, collectionId, key, value, isActive];
}
