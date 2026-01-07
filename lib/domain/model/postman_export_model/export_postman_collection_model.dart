import 'dart:convert';

/// ===============================================================
/// POSTMAN EXPORT MODELS (v2.1)
/// Prefix: ExportPostman*
/// Reason: Avoid conflict with existing Postman import models
/// ===============================================================

/// Root Postman Collection
class ExportPostmanCollection {
  final ExportPostmanInfo info;
  final List<ExportPostmanItem> item;
  final List<ExportPostmanVariable> variable;

  ExportPostmanCollection({
    required this.info,
    required this.item,
    required this.variable,
  });

  Map<String, dynamic> toJson() => {
        'info': info.toJson(),
        'item': item.map((e) => e.toJson()).toList(),
        if (variable.isNotEmpty)
          'variable': variable.map((e) => e.toJson()).toList(),
      };

  /// Pretty JSON for file export
  String toPrettyJson() =>
      const JsonEncoder.withIndent('  ').convert(toJson());
}

/// Collection metadata
class ExportPostmanInfo {
  final String name;
  final String? description;

  ExportPostmanInfo({
    required this.name,
    this.description,
  });

  Map<String, dynamic> toJson() => {
        '_postman_id': 'generated-by-app',
        'name': name,
        if (description != null) 'description': description,
        'schema':
            'https://schema.getpostman.com/json/collection/v2.1.0/collection.json',
      };
}

/// Folder or Request item
class ExportPostmanItem {
  final String name;
  final List<ExportPostmanItem>? item; // Children (folders)
  final ExportPostmanRequest? request; // Only for requests

  ExportPostmanItem({
    required this.name,
    this.item,
    this.request,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        if (item != null) 'item': item!.map((e) => e.toJson()).toList(),
        if (request != null) 'request': request!.toJson(),
      };
}

/// HTTP Request
class ExportPostmanRequest {
  final String method;
  final ExportPostmanUrl url;
  final List<ExportPostmanHeader> header;
  final ExportPostmanBody? body;

  ExportPostmanRequest({
    required this.method,
    required this.url,
    required this.header,
    this.body,
  });

  Map<String, dynamic> toJson() => {
        'method': method,
        'header': header.map((e) => e.toJson()).toList(),
        'url': url.toJson(), // 🔑 String URL (Postman compatible)
        if (body != null) 'body': body!.toJson(),
      };
}

/// URL (exported as raw string for Postman compatibility)
class ExportPostmanUrl {
  final String raw;

  ExportPostmanUrl({required this.raw});

  /// Postman supports raw string URL directly
  dynamic toJson() => raw;
}

/// HTTP Header
class ExportPostmanHeader {
  final String key;
  final String value;

  ExportPostmanHeader({
    required this.key,
    required this.value,
  });

  Map<String, dynamic> toJson() => {
        'key': key,
        'value': value,
      };
}

/// Query Parameter
class ExportPostmanQuery {
  final String key;
  final String value;

  ExportPostmanQuery({
    required this.key,
    required this.value,
  });

  Map<String, dynamic> toJson() => {
        'key': key,
        'value': value,
      };
}

/// Request Body (Raw mode for now; extendable later)
class ExportPostmanBody {
  final String mode; // raw | formdata | urlencoded | graphql
  final String raw;

  ExportPostmanBody({
    required this.mode,
    required this.raw,
  });

  Map<String, dynamic> toJson() => {
        'mode': mode,
        'raw': raw,
      };
}

/// Collection Variable
class ExportPostmanVariable {
  final String key;
  final String? value;

  ExportPostmanVariable({
    required this.key,
    this.value,
  });

  Map<String, dynamic> toJson() => {
        'key': key,
        'value': value,
      };
}
