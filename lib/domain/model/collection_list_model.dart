// To parse this JSON data, do
//
//     final collectionListModel = collectionListModelFromJson(jsonString);

import 'dart:convert';

List<CollectionListModel> collectionListModelFromJson(String str) =>
    List<CollectionListModel>.from(
      json.decode(str).map((x) => CollectionListModel.fromJson(x)),
    );

String collectionListModelToJson(List<CollectionListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CollectionListModel {
  final int? id;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CollectionListModel({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory CollectionListModel.fromJson(
    Map<String, dynamic> json,
  ) => CollectionListModel(
    id: json["id"],
    name: json["name"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
