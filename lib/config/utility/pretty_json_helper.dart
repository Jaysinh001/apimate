import 'dart:convert';

class JsonPrettyHelper {
  static bool isJson(String input) {
    try {
      json.decode(input);
      return true;
    } catch (_) {
      return false;
    }
  }

  static String prettyPrint(String input) {
    final decoded = json.decode(input);
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(decoded);
  }
}
