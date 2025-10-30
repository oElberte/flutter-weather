class AuthUser {
  AuthUser({
    required this.email,
    required this.sessionToken,
    required this.loginTimestamp,
  });

  factory AuthUser.fromSharedPreferences({
    required String email,
    required String sessionToken,
    required int timestamp,
  }) {
    return AuthUser(
      email: email,
      sessionToken: sessionToken,
      loginTimestamp: DateTime.fromMillisecondsSinceEpoch(timestamp),
    );
  }

  final String email;
  final String sessionToken;
  final DateTime loginTimestamp;
}
