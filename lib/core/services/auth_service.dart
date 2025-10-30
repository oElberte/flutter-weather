import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AuthService {
  final SharedPreferences _prefs;

  AuthService(this._prefs);

  static const String _keyEmail = 'user_email';
  static const String _keyTimestamp = 'login_timestamp';
  static const String _keyToken = 'session_token';

  Future<bool> login(String email, String password) async {
    final token = const Uuid().v4();
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    await _prefs.setString(_keyEmail, email);
    await _prefs.setInt(_keyTimestamp, timestamp);
    await _prefs.setString(_keyToken, token);

    return true;
  }

  Future<bool> isLoggedIn() async {
    final token = _prefs.getString(_keyToken);
    return token != null;
  }

  String? getEmail() {
    return _prefs.getString(_keyEmail);
  }

  String? getSessionToken() {
    return _prefs.getString(_keyToken);
  }

  int? getLoginTimestamp() {
    return _prefs.getInt(_keyTimestamp);
  }

  Future<void> logout() async {
    await _prefs.remove(_keyEmail);
    await _prefs.remove(_keyTimestamp);
    await _prefs.remove(_keyToken);
  }
}
