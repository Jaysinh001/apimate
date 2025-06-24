// To parse this JSON data, do
//
//     final collectionFileModel = collectionFileModelFromJson(jsonString);

import 'dart:convert';

CollectionFileModel collectionFileModelFromJson(String str) =>
    CollectionFileModel.fromJson(json.decode(str));

String collectionFileModelToJson(CollectionFileModel data) =>
    json.encode(data.toJson());

class CollectionFileModel {
  final Info? info;
  final List<Item>? item;

  CollectionFileModel({this.info, this.item});

  CollectionFileModel copyWith({Info? info, List<Item>? item}) =>
      CollectionFileModel(info: info ?? this.info, item: item ?? this.item);

  factory CollectionFileModel.fromJson(Map<String, dynamic> json) =>
      CollectionFileModel(
        info: json["info"] == null ? null : Info.fromJson(json["info"]),
        item:
            json["item"] == null
                ? []
                : List<Item>.from(json["item"]!.map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "info": info?.toJson(),
    "item":
        item == null ? [] : List<dynamic>.from(item!.map((x) => x.toJson())),
  };
}

class Info {
  final String? postmanId;
  final String? name;
  final String? schema;
  final String? exporterId;

  Info({this.postmanId, this.name, this.schema, this.exporterId});

  Info copyWith({
    String? postmanId,
    String? name,
    String? schema,
    String? exporterId,
  }) => Info(
    postmanId: postmanId ?? this.postmanId,
    name: name ?? this.name,
    schema: schema ?? this.schema,
    exporterId: exporterId ?? this.exporterId,
  );

  factory Info.fromJson(Map<String, dynamic> json) => Info(
    postmanId: json["_postman_id"],
    name: json["name"],
    schema: json["schema"],
    exporterId: json["_exporter_id"],
  );

  Map<String, dynamic> toJson() => {
    "_postman_id": postmanId,
    "name": name,
    "schema": schema,
    "_exporter_id": exporterId,
  };
}

class Item {
  final String? name;
  final List<dynamic>? item;
  final Request? request;
  final List<dynamic>? response;

  Item({this.name, this.item, this.request, this.response});

  Item copyWith({
    String? name,
    List<dynamic>? item,
    Request? request,
    List<dynamic>? response,
  }) => Item(
    name: name ?? this.name,
    item: item ?? this.item,
    request: request ?? this.request,
    response: response ?? this.response,
  );

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    name: json["name"],
    item:
        json["item"] == null
            ? []
            : List<dynamic>.from(json["item"]!.map((x) => x)),
    request: json["request"] == null ? null : Request.fromJson(json["request"]),
    response:
        json["response"] == null
            ? []
            : List<dynamic>.from(json["response"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "item": item == null ? [] : List<dynamic>.from(item!.map((x) => x)),
    "request": request?.toJson(),
    "response":
        response == null ? [] : List<dynamic>.from(response!.map((x) => x)),
  };
}

class Request {
  final Auth? auth;
  final String? method;
  final List<dynamic>? header;
  final Url? url;

  Request({this.auth, this.method, this.header, this.url});

  Request copyWith({
    Auth? auth,
    String? method,
    List<dynamic>? header,
    Url? url,
  }) => Request(
    auth: auth ?? this.auth,
    method: method ?? this.method,
    header: header ?? this.header,
    url: url ?? this.url,
  );

  factory Request.fromJson(Map<String, dynamic> json) => Request(
    auth: json["auth"] == null ? null : Auth.fromJson(json["auth"]),
    method: json["method"],
    header:
        json["header"] == null
            ? []
            : List<dynamic>.from(json["header"]!.map((x) => x)),
    url: json["url"] == null ? null : Url.fromJson(json["url"]),
  );

  Map<String, dynamic> toJson() => {
    "auth": auth?.toJson(),
    "method": method,
    "header": header == null ? [] : List<dynamic>.from(header!.map((x) => x)),
    "url": url?.toJson(),
  };
}

class Auth {
  final String? type;
  final List<Basic>? basic;

  Auth({this.type, this.basic});

  Auth copyWith({String? type, List<Basic>? basic}) =>
      Auth(type: type ?? this.type, basic: basic ?? this.basic);

  factory Auth.fromJson(Map<String, dynamic> json) => Auth(
    type: json["type"],
    basic:
        json["basic"] == null
            ? []
            : List<Basic>.from(json["basic"]!.map((x) => Basic.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "basic":
        basic == null ? [] : List<dynamic>.from(basic!.map((x) => x.toJson())),
  };
}

class Basic {
  final String? key;
  final String? value;
  final String? type;

  Basic({this.key, this.value, this.type});

  Basic copyWith({String? key, String? value, String? type}) => Basic(
    key: key ?? this.key,
    value: value ?? this.value,
    type: type ?? this.type,
  );

  factory Basic.fromJson(Map<String, dynamic> json) =>
      Basic(key: json["key"], value: json["value"], type: json["type"]);

  Map<String, dynamic> toJson() => {"key": key, "value": value, "type": type};
}

class Url {
  final String? raw;
  final String? protocol;
  final List<String>? host;
  final String? port;
  final List<String>? path;

  Url({this.raw, this.protocol, this.host, this.port, this.path});

  Url copyWith({
    String? raw,
    String? protocol,
    List<String>? host,
    String? port,
    List<String>? path,
  }) => Url(
    raw: raw ?? this.raw,
    protocol: protocol ?? this.protocol,
    host: host ?? this.host,
    port: port ?? this.port,
    path: path ?? this.path,
  );

  factory Url.fromJson(Map<String, dynamic> json) => Url(
    raw: json["raw"],
    protocol: json["protocol"],
    host:
        json["host"] == null
            ? []
            : List<String>.from(json["host"]!.map((x) => x)),
    port: json["port"],
    path:
        json["path"] == null
            ? []
            : List<String>.from(json["path"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "raw": raw,
    "protocol": protocol,
    "host": host == null ? [] : List<dynamic>.from(host!.map((x) => x)),
    "port": port,
    "path": path == null ? [] : List<dynamic>.from(path!.map((x) => x)),
  };
}
