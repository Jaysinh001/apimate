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
  final List<Event>? event;

  Item({this.name, this.item, this.request, this.response, this.event});

  Item copyWith({
    String? name,
    List<dynamic>? item,
    Request? request,
    List<dynamic>? response,
    List<Event>? event,
  }) => Item(
    name: name ?? this.name,
    item: item ?? this.item,
    request: request ?? this.request,
    response: response ?? this.response,
    event: event ?? this.event,
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
    event:
        json["event"] == null
            ? []
            : List<Event>.from(json["event"]!.map((x) => Event.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "item": item == null ? [] : List<dynamic>.from(item!.map((x) => x)),
    "request": request?.toJson(),
    "response":
        response == null ? [] : List<dynamic>.from(response!.map((x) => x)),
    "event":
        event == null ? [] : List<dynamic>.from(event!.map((x) => x.toJson())),
  };
}

class Event {
  final String? listen;
  final Script? script;

  Event({this.listen, this.script});

  Event copyWith({String? listen, Script? script}) =>
      Event(listen: listen ?? this.listen, script: script ?? this.script);

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    listen: json["listen"],
    script: json["script"] == null ? null : Script.fromJson(json["script"]),
  );

  Map<String, dynamic> toJson() => {
    "listen": listen,
    "script": script?.toJson(),
  };
}

class Script {
  final List<String>? exec;
  final String? type;

  Script({this.exec, this.type});

  Script copyWith({List<String>? exec, String? type}) =>
      Script(exec: exec ?? this.exec, type: type ?? this.type);

  factory Script.fromJson(Map<String, dynamic> json) => Script(
    exec:
        json["exec"] == null
            ? []
            : List<String>.from(json["exec"]!.map((x) => x)),
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "exec": exec == null ? [] : List<dynamic>.from(exec!.map((x) => x)),
    "type": type,
  };
}

class Request {
  final Auth? auth;
  final String? method;
  final List<Header>? header;
  final Url? url;
  final Body? body;

  Request({this.auth, this.method, this.header, this.url, this.body});

  Request copyWith({
    Auth? auth,
    String? method,
    List<Header>? header,
    Url? url,
    Body? body,
  }) => Request(
    auth: auth ?? this.auth,
    method: method ?? this.method,
    header: header ?? this.header,
    url: url ?? this.url,
    body: body ?? this.body,
  );

  factory Request.fromJson(Map<String, dynamic> json) => Request(
    auth: json["auth"] == null ? null : Auth.fromJson(json["auth"]),
    method: json["method"],
    header:
        json["header"] == null
            ? []
            : List<Header>.from(json["header"]!.map((x) => Header.fromJson(x))),
    url: json["url"] == null ? null : Url.fromJson(json["url"]),
    body: json["body"] == null ? null : Body.fromJson(json["body"]),
  );

  Map<String, dynamic> toJson() => {
    "auth": auth?.toJson(),
    "method": method,
    "header":
        header == null
            ? []
            : List<dynamic>.from(header!.map((x) => x.toJson())),
    "url": url?.toJson(),
    "body": body?.toJson(),
  };
}

class Auth {
  final String? type;
  final List<Header>? basic;

  Auth({this.type, this.basic});

  Auth copyWith({String? type, List<Header>? basic}) =>
      Auth(type: type ?? this.type, basic: basic ?? this.basic);

  factory Auth.fromJson(Map<String, dynamic> json) => Auth(
    type: json["type"],
    basic:
        json["basic"] == null
            ? []
            : List<Header>.from(json["basic"]!.map((x) => Header.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "basic":
        basic == null ? [] : List<dynamic>.from(basic!.map((x) => x.toJson())),
  };
}

class Header {
  final String? key;
  final String? value;
  final String? type;

  Header({this.key, this.value, this.type});

  Header copyWith({String? key, String? value, String? type}) => Header(
    key: key ?? this.key,
    value: value ?? this.value,
    type: type ?? this.type,
  );

  factory Header.fromJson(Map<String, dynamic> json) =>
      Header(key: json["key"], value: json["value"], type: json["type"]);

  Map<String, dynamic> toJson() => {"key": key, "value": value, "type": type};
}

class Body {
  final String? mode;
  final List<Header>? formdata;

  Body({this.mode, this.formdata});

  Body copyWith({String? mode, List<Header>? formdata}) =>
      Body(mode: mode ?? this.mode, formdata: formdata ?? this.formdata);

  factory Body.fromJson(Map<String, dynamic> json) => Body(
    mode: json["mode"],
    formdata:
        json["formdata"] == null
            ? []
            : List<Header>.from(
              json["formdata"]!.map((x) => Header.fromJson(x)),
            ),
  );

  Map<String, dynamic> toJson() => {
    "mode": mode,
    "formdata":
        formdata == null
            ? []
            : List<dynamic>.from(formdata!.map((x) => x.toJson())),
  };
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
