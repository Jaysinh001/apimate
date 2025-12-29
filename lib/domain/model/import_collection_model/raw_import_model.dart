class PostmanCollection {
  final PostmanInfo? info;
  final List<PostmanItem>? item;
  final List<PostmanEvent>? event;
  final List<PostmanVariable>? variable;
  final PostmanAuth? auth;
  final Map<String, dynamic>? protocolProfileBehavior;

 const PostmanCollection({
    this.info,
    this.item,
    this.event,
    this.variable,
    this.auth,
    this.protocolProfileBehavior,
  });

  factory PostmanCollection.fromJson(Map<String, dynamic> json) {
    return PostmanCollection(
      info: json['info'] != null
          ? PostmanInfo.fromJson(json['info'])
          : null,
      item: (json['item'] as List?)
          ?.map((e) => PostmanItem.fromJson(e))
          .toList(),
      event: (json['event'] as List?)
          ?.map((e) => PostmanEvent.fromJson(e))
          .toList(),
      variable: (json['variable'] as List?)
          ?.map((e) => PostmanVariable.fromJson(e))
          .toList(),
      auth: json['auth'] != null ? PostmanAuth.fromJson(json['auth']) : null,
      protocolProfileBehavior:
          json['protocolProfileBehavior'] as Map<String, dynamic>?,
    );
  }
}


class PostmanInfo {
  final String? name;
  final String? postmanId;
  final dynamic description;
  final dynamic version;
  final String? schema;

  const PostmanInfo({
    this.name,
    this.postmanId,
    this.description,
    this.version,
    this.schema,
  });

  factory PostmanInfo.fromJson(Map<String, dynamic> json) {
    return PostmanInfo(
      name: json['name'],
      postmanId: json['_postman_id'],
      description: json['description'],
      version: json['version'],
      schema: json['schema'],
    );
  }
}
class PostmanItem {
  final String? id;
  final String? name;
  final dynamic description;
  final List<PostmanItem>? item; // folder children
  final PostmanRequest? request; // request
  final List<PostmanResponse>? response;
  final List<PostmanEvent>? event;
  final List<PostmanVariable>? variable;
  final PostmanAuth? auth;

  PostmanItem({
    this.id,
    this.name,
    this.description,
    this.item,
    this.request,
    this.response,
    this.event,
    this.variable,
    this.auth,
  });

  factory PostmanItem.fromJson(Map<String, dynamic> json) {
    return PostmanItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      item: (json['item'] as List?)
          ?.map((e) => PostmanItem.fromJson(e))
          .toList(),
      request: json['request'] != null
          ? PostmanRequest.fromJson(json['request'])
          : null,
      response: (json['response'] as List?)
          ?.map((e) => PostmanResponse.fromJson(e))
          .toList(),
      event: (json['event'] as List?)
          ?.map((e) => PostmanEvent.fromJson(e))
          .toList(),
      variable: (json['variable'] as List?)
          ?.map((e) => PostmanVariable.fromJson(e))
          .toList(),
      auth: json['auth'] != null ? PostmanAuth.fromJson(json['auth']) : null,
    );
  }

  bool get isFolder => item != null && item!.isNotEmpty;
  bool get isRequest => request != null;
}
class PostmanRequest {
  final dynamic url; // string OR object
  final String? method;
  final dynamic header; // string OR array
  final PostmanBody? body;
  final dynamic description;
  final PostmanAuth? auth;

  PostmanRequest({
    this.url,
    this.method,
    this.header,
    this.body,
    this.description,
    this.auth,
  });

  factory PostmanRequest.fromJson(dynamic json) {
    if (json is String) {
      return PostmanRequest(url: json);
    }

    return PostmanRequest(
      url: json['url'],
      method: json['method'],
      header: json['header'],
      body:
          json['body'] != null ? PostmanBody.fromJson(json['body']) : null,
      description: json['description'],
      auth: json['auth'] != null ? PostmanAuth.fromJson(json['auth']) : null,
    );
  }
}
class PostmanBody {
  final String? mode;
  final dynamic raw;
  final List<PostmanKeyValue>? urlencoded;
  final List<PostmanFormData>? formdata;
  final PostmanFile? file;
  final Map<String, dynamic>? graphql;
  final bool? disabled;

  PostmanBody({
    this.mode,
    this.raw,
    this.urlencoded,
    this.formdata,
    this.file,
    this.graphql,
    this.disabled,
  });

  factory PostmanBody.fromJson(Map<String, dynamic> json) {
    return PostmanBody(
      mode: json['mode'],
      raw: json['raw'],
      urlencoded: (json['urlencoded'] as List?)
          ?.map((e) => PostmanKeyValue.fromJson(e))
          .toList(),
      formdata: (json['formdata'] as List?)
          ?.map((e) => PostmanFormData.fromJson(e))
          .toList(),
      file: json['file'] != null ? PostmanFile.fromJson(json['file']) : null,
      graphql: json['graphql'],
      disabled: json['disabled'],
    );
  }
}

class PostmanFile {
  final String? src;
  final String? content;

  PostmanFile({
    this.src,
    this.content,
  });

  factory PostmanFile.fromJson(Map<String, dynamic> json) {
    return PostmanFile(
      src: json['src'],
      content: json['content'],
    );
  }
}

class PostmanKeyValue {
  final String? key;
  final dynamic value;
  final bool? disabled;
  final dynamic description;

  PostmanKeyValue({
    this.key,
    this.value,
    this.disabled,
    this.description,
  });

  factory PostmanKeyValue.fromJson(Map<String, dynamic> json) {
    return PostmanKeyValue(
      key: json['key'],
      value: json['value'],
      disabled: json['disabled'],
      description: json['description'],
    );
  }
}

class PostmanFormData extends PostmanKeyValue {
  final String? type;
  final dynamic src;
  final String? contentType;

  PostmanFormData({
    super.key,
    super.value,
    super.disabled,
    super.description,
    this.type,
    this.src,
    this.contentType,
  });

  factory PostmanFormData.fromJson(Map<String, dynamic> json) {
    return PostmanFormData(
      key: json['key'],
      value: json['value'],
      disabled: json['disabled'],
      description: json['description'],
      type: json['type'],
      src: json['src'],
      contentType: json['contentType'],
    );
  }
}
class PostmanAuth {
  final String? type;
  final Map<String, List<PostmanAuthAttribute>> data;

  PostmanAuth({
    this.type,
    required this.data,
  });

  factory PostmanAuth.fromJson(Map<String, dynamic> json) {
    final Map<String, List<PostmanAuthAttribute>> parsed = {};

    json.forEach((key, value) {
      if (value is List) {
        parsed[key] =
            value.map((e) => PostmanAuthAttribute.fromJson(e)).toList();
      }
    });

    return PostmanAuth(
      type: json['type'],
      data: parsed,
    );
  }
}

class PostmanAuthAttribute {
  final String? key;
  final dynamic value;
  final String? type;

  PostmanAuthAttribute({this.key, this.value, this.type});

  factory PostmanAuthAttribute.fromJson(Map<String, dynamic> json) {
    return PostmanAuthAttribute(
      key: json['key'],
      value: json['value'],
      type: json['type'],
    );
  }
}
class PostmanEvent {
  final String? listen;
  final PostmanScript? script;
  final bool? disabled;

  PostmanEvent({this.listen, this.script, this.disabled});

  factory PostmanEvent.fromJson(Map<String, dynamic> json) {
    return PostmanEvent(
      listen: json['listen'],
      script:
          json['script'] != null ? PostmanScript.fromJson(json['script']) : null,
      disabled: json['disabled'],
    );
  }
}

class PostmanScript {
  final String? type;
  final dynamic exec;
  final String? name;

  PostmanScript({this.type, this.exec, this.name});

  factory PostmanScript.fromJson(Map<String, dynamic> json) {
    return PostmanScript(
      type: json['type'],
      exec: json['exec'],
      name: json['name'],
    );
  }
}
class PostmanVariable {
  final String? id;
  final String? key;
  final dynamic value;
  final String? type;
  final bool? disabled;

  PostmanVariable({
    this.id,
    this.key,
    this.value,
    this.type,
    this.disabled,
  });

  factory PostmanVariable.fromJson(Map<String, dynamic> json) {
    return PostmanVariable(
      id: json['id'],
      key: json['key'],
      value: json['value'],
      type: json['type'],
      disabled: json['disabled'],
    );
  }
}
class PostmanResponse {
  final String? name;
  final int? code;
  final String? status;
  final dynamic body;

  PostmanResponse({
    this.name,
    this.code,
    this.status,
    this.body,
  });

  factory PostmanResponse.fromJson(Map<String, dynamic> json) {
    return PostmanResponse(
      name: json['name'],
      code: json['code'],
      status: json['status'],
      body: json['body'],
    );
  }
}
