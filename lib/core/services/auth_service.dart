import 'package:uuid/uuid.dart';
import 'package:weather/core/interfaces/local_storage.dart';

class AuthService {
  AuthService(this._storage);

  final LocalStorage _storage;

  static const String _keyEmail = 'user_email';
  static const String _keyTimestamp = 'login_timestamp';
  static const String _keyToken = 'session_token';

  Future<bool> login(String email, String password) async {
    final token = const Uuid().v4();
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    await _storage.setString(_keyEmail, email);
    await _storage.setInt(_keyTimestamp, timestamp);
    await _storage.setString(_keyToken, token);

    return true;
  }

  Future<bool> isLoggedIn() async {
    final token = _storage.getString(_keyToken);
    return token != null;
  }

  String? getEmail() {
    return _storage.getString(_keyEmail);
  }

  String? getSessionToken() {
    return _storage.getString(_keyToken);
  }

  int? getLoginTimestamp() {
    return _storage.getInt(_keyTimestamp);
  }

  Future<void> logout() async {
    await _storage.remove(_keyEmail);
    await _storage.remove(_keyTimestamp);
    await _storage.remove(_keyToken);
  }
}
