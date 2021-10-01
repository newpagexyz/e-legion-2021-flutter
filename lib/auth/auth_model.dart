class LoginPassword {
  final String email;
  final String password;

  LoginPassword({required this.email, required this.password});
}

class Credentials {
  final String session;
  final String token;

  Credentials({required this.session, required this.token});
  factory Credentials.fromJson(Map<String, dynamic> json) {
    return Credentials(session: json['session'], token: json['token']);
  }
}
