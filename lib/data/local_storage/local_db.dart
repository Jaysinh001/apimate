import 'package:hive/hive.dart';

// ignore: constant_identifier_names
enum KEYNAME { TOKEN, DRIVER }

class HiveHelper {
  static const _boxName = 'SafeDropStorageBox'; // Single box for all app data

  /// Opens the single Hive box (called internally)
  static Future<Box> _openBox() async {
    return await Hive.openBox(_boxName);
  }

  /// Saves a value (any data type) to the box
  static Future<void> saveData(String key, dynamic value) async {
    var box = await _openBox();
    await box.put(key, value);
  }

  /// Retrieves a value (any data type) from the box
  static Future<dynamic> getData(String key) async {
    var box = await _openBox();
    return box.get(key);
  }

  /// Deletes a value by key from the box
  static Future<void> deleteData(String key) async {
    var box = await _openBox();
    await box.delete(key);
  }

  /// Clears all data in the box
  static Future<void> clearBox() async {
    var box = await _openBox();
    await box.clear();
  }

  /// Checks if a key exists in the box
  static Future<bool> containsKey(String key) async {
    var box = await _openBox();
    return box.containsKey(key);
  }
}
