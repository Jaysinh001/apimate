// To parse this JSON data, do
//
//     final paramsListModel = paramsListModelFromJson(jsonString);

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
  final String? key;
  final String? value;
  final int? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ParamsListModel({
    this.id,
    this.apiId,
    this.key,
    this.value,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  ParamsListModel copyWith({
    int? id,
    int? apiId,
    String? key,
    String? value,
    int? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ParamsListModel(
    id: id ?? this.id,
    apiId: apiId ?? this.apiId,
    key: key ?? this.key,
    value: value ?? this.value,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory ParamsListModel.fromJson(
    Map<String, dynamic> json,
  ) => ParamsListModel(
    id: json["id"],
    apiId: json["api_id"],
    key: json["key"],
    value: json["value"],
    isActive: json["is_active"],
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
    "is_active": isActive,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
