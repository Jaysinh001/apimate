// To parse this JSON data, do
//
//     final headersListModel = headersListModelFromJson(jsonString);

import 'dart:convert';

List<HeadersListModel> headersListModelFromJson(String str) =>
    List<HeadersListModel>.from(
      json.decode(str).map((x) => HeadersListModel.fromJson(x)),
    );

String headersListModelToJson(List<HeadersListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HeadersListModel {
  final int? id;
  final int? apiId;
  final String? key;
  final String? value;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  HeadersListModel({
    this.id,
    this.apiId,
    this.key,
    this.value,
    this.createdAt,
    this.updatedAt,
  });

  factory HeadersListModel.fromJson(
    Map<String, dynamic> json,
  ) => HeadersListModel(
    id: json["id"],
    apiId: json["api_id"],
    key: json["key"],
    value: json["value"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "api_id": apiId,
    "key": key,
    "value": value,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
