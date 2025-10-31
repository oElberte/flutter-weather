abstract class LocalStorage {
  Future<bool> setBool(String key, bool value);
  Future<bool> setInt(String key, int value);
  Future<bool> setString(String key, String value);
  Future<bool> setDouble(String key, double value);
  Future<bool> setStringList(String key, List<String> value);

  bool? getBool(String key);
  int? getInt(String key);
  String? getString(String key);
  double? getDouble(String key);
  List<String>? getStringList(String key);

  Future<bool> remove(String key);
  Future<bool> clear();
  bool containsKey(String key);
}
