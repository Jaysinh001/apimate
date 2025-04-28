// To parse this JSON data, do
//
//     final getApiListModel = getApiListModelFromJson(jsonString);

import 'dart:convert';

List<GetApiListModel> getApiListModelFromJson(String str) =>
    List<GetApiListModel>.from(
      json.decode(str).map((x) => GetApiListModel.fromJson(x)),
    );

String getApiListModelToJson(List<GetApiListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetApiListModel {
  final int? id;
  final int? collectionId;
  final String? name;
  final String? method;
  final String? url;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  GetApiListModel({
    this.id,
    this.collectionId,
    this.name,
    this.method,
    this.url,
    this.createdAt,
    this.updatedAt,
  });

  GetApiListModel copyWith({
    int? id,
    int? collectionId,
    String? name,
    String? method,
    String? url,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => GetApiListModel(
    id: id ?? this.id,
    collectionId: collectionId ?? this.collectionId,
    name: name ?? this.name,
    method: method ?? this.method,
    url: url ?? this.url,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory GetApiListModel.fromJson(
    Map<String, dynamic> json,
  ) => GetApiListModel(
    id: json["id"],
    collectionId: json["collection_id"],
    name: json["name"],
    method: json["method"],
    url: json["url"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "collection_id": collectionId,
    "name": name,
    "method": method,
    "url": url,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
