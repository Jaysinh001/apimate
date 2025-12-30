class RequestClientData {
  final int requestId;
  final String method;
  final String rawUrl;

  final Map<String, String> headers;
  final Map<String, String> queryParams;

  final RequestBodyData? body;

  // 🔑 NEW: collection variables
  final Map<String, String?> collectionVariables;
  final Set<String> inactiveCollectionVariables;

  RequestClientData({
    required this.requestId,
    required this.method,
    required this.rawUrl,
    required this.headers,
    required this.queryParams,
    required this.collectionVariables,
    required this.inactiveCollectionVariables,
    this.body,
  });
}




enum RequestBodyType { none, raw }

class RequestBodyData {
  final RequestBodyType type;
  final String content;
  final String? contentType;

  const RequestBodyData({
    required this.type,
    required this.content,
    this.contentType,
  });
}
