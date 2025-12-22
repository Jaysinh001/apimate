// import 'dart:convert';


// PostmanCollection postmanCollectionFromJson(String str) =>
//     PostmanCollection.fromJson(json.decode(str));

// String postmanCollectionToJson(PostmanCollection data) =>
//     json.encode(data.toJson());


// /// ===============================
// /// ROOT MODEL
// /// ===============================
// class PostmanCollection {
//   Info? info;
//   List<Item>? item;
//   List<Event>? event;
//   List<Variable>? variable;

//   PostmanCollection({
//     this.info,
//     this.item,
//     this.event,
//     this.variable,
//   });

//   factory PostmanCollection.fromJson(Map<String, dynamic>? json) {
//     if (json == null) return PostmanCollection();

//     return PostmanCollection(
//       info: Info.fromJson(json['info']),
//       item: (json['item'] as List?)
//           ?.map((e) => Item.fromJson(e))
//           .toList(),
//       event: (json['event'] as List?)
//           ?.map((e) => Event.fromJson(e))
//           .toList(),
//       variable: (json['variable'] as List?)
//           ?.map((e) => Variable.fromJson(e))
//           .toList(),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'info': info?.toJson(),
//         'item': item?.map((e) => e.toJson()).toList(),
//         'event': event?.map((e) => e.toJson()).toList(),
//         'variable': variable?.map((e) => e.toJson()).toList(),
//       };
// }

// /// ===============================
// /// INFO
// /// ===============================
// class Info {
//   String? name;
//   String? schema;
//   String? description;

//   Info({this.name, this.schema, this.description});

//   factory Info.fromJson(Map<String, dynamic>? json) {
//     if (json == null) return Info();

//     return Info(
//       name: json['name'] as String?,
//       schema: json['schema'] as String?,
//       description: json['description'] as String?,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'name': name,
//         'schema': schema,
//         'description': description,
//       };
// }

// /// ===============================
// /// ITEM (Folder or Request)
// /// ===============================
// class Item {
//   String? name;
//   Request? request;
//   List<Item>? item;
//   List<Event>? event;

//   Item({this.name, this.request, this.item, this.event});

//   factory Item.fromJson(Map<String, dynamic>? json) {
//     if (json == null) return Item();

//     return Item(
//       name: json['name'] as String?,
//       request: Request.fromJson(json['request']),
//       item: (json['item'] as List?)
//           ?.map((e) => Item.fromJson(e))
//           .toList(),
//       event: (json['event'] as List?)
//           ?.map((e) => Event.fromJson(e))
//           .toList(),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'name': name,
//         'request': request?.toJson(),
//         'item': item?.map((e) => e.toJson()).toList(),
//         'event': event?.map((e) => e.toJson()).toList(),
//       };
// }

// /// ===============================
// /// REQUEST
// /// ===============================
// class Request {
//   String? method;
//   List<Header>? header;
//   Body? body;
//   Url? url;
//   String? description;
//   Auth? auth;

//   Request({
//     this.method,
//     this.header,
//     this.body,
//     this.url,
//     this.description,
//     this.auth,
//   });

//   factory Request.fromJson(Map<String, dynamic>? json) {
//     if (json == null) return Request();

//     return Request(
//       method: json['method'] as String?,
//       description: json['description'] as String?,
//       header: (json['header'] as List?)
//           ?.map((e) => Header.fromJson(e))
//           .toList(),
//       body: Body.fromJson(json['body']),
//       url: Url.fromJson(json['url']),
//       auth: Auth.fromJson(json['auth']),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'method': method,
//         'description': description,
//         'header': header?.map((e) => e.toJson()).toList(),
//         'body': body?.toJson(),
//         'url': url?.toJson(),
//         'auth': auth?.toJson(),
//       };
// }

// /// ===============================
// /// URL
// /// ===============================
// class Url {
//   String? raw;
//   String? protocol;
//   List<String>? host;
//   List<String>? path;
//   List<Query>? query;

//   Url({this.raw, this.protocol, this.host, this.path, this.query});

//   factory Url.fromJson(Map<String, dynamic>? json) {
//     if (json == null) return Url();

//     return Url(
//       raw: json['raw'] as String?,
//       protocol: json['protocol'] as String?,
//       host: (json['host'] as List?)?.map((e) => e.toString()).toList(),
//       path: (json['path'] as List?)?.map((e) => e.toString()).toList(),
//       query: (json['query'] as List?)
//           ?.map((e) => Query.fromJson(e))
//           .toList(),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'raw': raw,
//         'protocol': protocol,
//         'host': host,
//         'path': path,
//         'query': query?.map((e) => e.toJson()).toList(),
//       };
// }

// /// ===============================
// /// QUERY
// /// ===============================
// class Query {
//   String? key;
//   String? value;
//   bool? disabled;

//   Query({this.key, this.value, this.disabled});

//   factory Query.fromJson(Map<String, dynamic>? json) {
//     if (json == null) return Query();

//     return Query(
//       key: json['key'] as String?,
//       value: json['value']?.toString(),
//       disabled: json['disabled'] as bool?,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'key': key,
//         'value': value,
//         'disabled': disabled,
//       };
// }

// /// ===============================
// /// HEADER
// /// ===============================
// class Header {
//   String? key;
//   String? value;
//   String? type;
//   bool? disabled;

//   Header({this.key, this.value, this.type, this.disabled});

//   factory Header.fromJson(Map<String, dynamic>? json) {
//     if (json == null) return Header();

//     return Header(
//       key: json['key'] as String?,
//       value: json['value']?.toString(),
//       type: json['type'] as String?,
//       disabled: json['disabled'] as bool?,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'key': key,
//         'value': value,
//         'type': type,
//         'disabled': disabled,
//       };
// }

// /// ===============================
// /// BODY
// /// ===============================
// class Body {
//   String? mode;
//   String? raw;
//   List<FormData>? formdata;

//   Body({this.mode, this.raw, this.formdata});

//   factory Body.fromJson(Map<String, dynamic>? json) {
//     if (json == null) return Body();

//     return Body(
//       mode: json['mode'] as String?,
//       raw: json['raw'] as String?,
//       formdata: (json['formdata'] as List?)
//           ?.map((e) => FormData.fromJson(e))
//           .toList(),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'mode': mode,
//         'raw': raw,
//         'formdata': formdata?.map((e) => e.toJson()).toList(),
//       };
// }

// /// ===============================
// /// FORM DATA
// /// ===============================
// class FormData {
//   String? key;
//   String? value;
//   String? type;
//   bool? disabled;

//   FormData({this.key, this.value, this.type, this.disabled});

//   factory FormData.fromJson(Map<String, dynamic>? json) {
//     if (json == null) return FormData();

//     return FormData(
//       key: json['key'] as String?,
//       value: json['value']?.toString(),
//       type: json['type'] as String?,
//       disabled: json['disabled'] as bool?,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'key': key,
//         'value': value,
//         'type': type,
//         'disabled': disabled,
//       };
// }

// /// ===============================
// /// EVENT
// /// ===============================
// class Event {
//   String? listen;
//   Script? script;

//   Event({this.listen, this.script});

//   factory Event.fromJson(Map<String, dynamic>? json) {
//     if (json == null) return Event();

//     return Event(
//       listen: json['listen'] as String?,
//       script: Script.fromJson(json['script']),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'listen': listen,
//         'script': script?.toJson(),
//       };
// }

// /// ===============================
// /// SCRIPT
// /// ===============================
// class Script {
//   String? type;
//   List<String>? exec;

//   Script({this.type, this.exec});

//   factory Script.fromJson(Map<String, dynamic>? json) {
//     if (json == null) return Script();

//     return Script(
//       type: json['type'] as String?,
//       exec: (json['exec'] as List?)?.map((e) => e.toString()).toList(),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'type': type,
//         'exec': exec,
//       };
// }

// /// ===============================
// /// VARIABLE
// /// ===============================
// class Variable {
//   String? key;
//   dynamic value;
//   String? type;

//   Variable({this.key, this.value, this.type});

//   factory Variable.fromJson(Map<String, dynamic>? json) {
//     if (json == null) return Variable();

//     return Variable(
//       key: json['key'] as String?,
//       value: json['value'],
//       type: json['type'] as String?,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'key': key,
//         'value': value,
//         'type': type,
//       };
// }

// /// ===============================
// /// AUTH
// /// ===============================
// class Auth {
//   String? type;
//   Map<String, dynamic>? data;

//   Auth({this.type, this.data});

//   factory Auth.fromJson(Map<String, dynamic>? json) {
//     if (json == null) return Auth();

//     return Auth(
//       type: json['type'] as String?,
//       data: json,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'type': type,
//         ...?data,
//       };
// }
