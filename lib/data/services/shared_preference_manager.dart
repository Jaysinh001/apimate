import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/theme_bloc/theme_bloc.dart';

// Extension method to easily convert between Enum and String
extension ThemeNamesExtension on ThemeNames {
  String get value => name; // Use name property
  //String get value => this.toString().split('.').last;  // <-- this is the old way, avoid it.
  static ThemeNames? fromValue(String? value) {
    if (value == null) return null;
    return ThemeNames.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ThemeNames.dracula, // Provide a default value
    );
  }
}

class SharedPreferencesManager {
  static final SharedPreferencesManager _instance =
      SharedPreferencesManager._internal();
  factory SharedPreferencesManager() => _instance;
  SharedPreferencesManager._internal();

  SharedPreferences? _prefs;

  // Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  //Specific method for ThemeNames (RECOMMENDED)
  Future<void> setThemeName(ThemeNames theme) async {
    if (_prefs == null) {
      await init(); // Ensure _prefs is initialized
    }
    await _prefs?.setString("appTheme", theme.value);
  }

  ThemeNames getThemeName() {
    if (_prefs == null) {
      init();
      return ThemeNames.dracula;
    }
    final String? themeValue = _prefs?.getString("appTheme");
    return ThemeNamesExtension.fromValue(themeValue) ?? ThemeNames.dracula;
  }

  // Clear all data (for testing or reset)
  Future<void> clear() async {
    if (_prefs == null) {
      await init();
    }
    await _prefs?.clear();
  }
}
