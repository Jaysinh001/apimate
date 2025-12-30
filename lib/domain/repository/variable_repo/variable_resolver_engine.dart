import '../../model/variable_resolution_engine_model/variable_resolution_engine_model.dart';

class VariableResolver {
  static final RegExp _varPattern = RegExp(r'\{\{([\w\-\.]+)\}\}');

  /// Resolve variables in a raw string
  ///
  /// Resolution priority:
  ///   sources[0] -> highest priority
  ///   sources[last] -> lowest priority
  static VariableResolutionResult resolve(
    String rawValue, {
    required List<VariableSource> sources,
  }) {
    final usedKeys = <String>{};
    final unresolvedKeys = <String>{};
    final warnings = <String>[];
    final errors = <String>[];

    String resolved = rawValue;

    final matches = _varPattern.allMatches(rawValue);

    for (final match in matches) {
      final key = match.group(1);

      if (key == null || key.isEmpty) {
        errors.add('Malformed variable syntax');
        continue;
      }

      bool resolvedFlag = false;

      for (final source in sources) {
        // Disabled variable
        if (source.inactiveKeys.contains(key)) {
          warnings.add('Variable "$key" is disabled');
          resolvedFlag = true;
          break;
        }

        if (source.values.containsKey(key)) {
          final value = source.values[key];

          if (value == null || value.isEmpty) {
            warnings.add('Variable "$key" has empty value');
          }

          resolved = resolved.replaceAll('{{${key}}}', value ?? '');
          usedKeys.add(key);
          resolvedFlag = true;
          break;
        }
      }

      if (!resolvedFlag) {
        unresolvedKeys.add(key);
        warnings.add('Variable "$key" is not defined');
      }
    }

    return VariableResolutionResult(
      resolvedValue: resolved,
      usedKeys: usedKeys,
      unresolvedKeys: unresolvedKeys,
      warnings: warnings,
      errors: errors,
    );
  }
}
