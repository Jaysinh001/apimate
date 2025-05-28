// To parse this JSON data, do
//
//     final ParamsListModel = headersListModelFromJson(jsonString);

import 'dart:convert';

List<ParamsListModel> paramsListModelFromJson(String str) =>
    List<ParamsListModel>.from(
      json.decode(str).map((x) => ParamsListModel.fromJson(x)),
    );

String paramsListModelToJson(List<ParamsListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ParamsListModel {
  final int? id;
  final int? apiId;
  final int? isActive;
  final String? key;
  final String? value;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ParamsListModel({
    this.id,
    this.apiId,
    this.isActive,
    this.key,
    this.value,
    this.createdAt,
    this.updatedAt,
  });

  factory ParamsListModel.fromJson(
    Map<String, dynamic> json,
  ) => ParamsListModel(
    id: json["id"],
    apiId: json["api_id"],
    isActive: json["is_active"],
    key: json["key"],
    value: json["value"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "is_active": isActive,
    "api_id": apiId,
    "key": key,
    "value": value,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
