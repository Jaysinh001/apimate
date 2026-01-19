enum AuthType { none, bearer, apiKey, basic, oauth2 }

enum ApiKeyLocation { header, query }

class RequestAuth {
  final AuthType type;
  final bool isActive;

  // Bearer
  final String? token;

  // API Key
  final String? apiKey;
  final String? apiValue;
  final ApiKeyLocation? apiLocation;

  // Basic Auth
  final String? username;
  final String? password;

  const RequestAuth({
    required this.type,
    this.isActive = true,
    this.token,
    this.apiKey,
    this.apiValue,
    this.apiLocation,
    this.username,
    this.password,
  });

  factory RequestAuth.none() {
    return const RequestAuth(type: AuthType.none);
  }
}

extension RequestAuthCopy on RequestAuth {
  RequestAuth copyWith({
    AuthType? type,
    bool? isActive,
    String? token,
    String? apiKey,
    String? apiValue,
    ApiKeyLocation? apiLocation,
    String? username,
    String? password,
  }) {
    return RequestAuth(
      type: type ?? this.type,
      isActive: isActive ?? this.isActive,
      token: token ?? this.token,
      apiKey: apiKey ?? this.apiKey,
      apiValue: apiValue ?? this.apiValue,
      apiLocation: apiLocation ?? this.apiLocation,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }
}
