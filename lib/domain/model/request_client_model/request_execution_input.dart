class RequestExecutionInput {
  final String method;
  final String url;
  final Map<String, String> headers;
  final Map<String, String> queryParams;
  final String? body;
  final String? contentType;

  const RequestExecutionInput({
    required this.method,
    required this.url,
    required this.headers,
    required this.queryParams,
    this.body,
    this.contentType,
  });
}
