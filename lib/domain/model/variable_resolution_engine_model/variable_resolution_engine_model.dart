class VariableResolutionResult {
  final String resolvedValue;
  final Set<String> usedKeys;
  final Set<String> unresolvedKeys;
  final List<String> warnings;
  final List<String> errors;

  const VariableResolutionResult({
    required this.resolvedValue,
    required this.usedKeys,
    required this.unresolvedKeys,
    required this.warnings,
    required this.errors,
  });

  bool get hasErrors => errors.isNotEmpty;
  bool get hasWarnings => warnings.isNotEmpty;
}




class VariableSource {
  final Map<String, String?> values; // key -> value
  final Set<String> inactiveKeys;    // disabled variables

  const VariableSource({
    required this.values,
    this.inactiveKeys = const {},
  });
}
