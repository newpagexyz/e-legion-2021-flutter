class LoginPassword {
  final String email;
  final String password;

  LoginPassword({required this.email, required this.password});
}

class Credentials {
  final String id;
  final String token;

  Credentials({required this.id, required this.token});
  factory Credentials.fromJson(Map<String, dynamic> json) {
    return Credentials(id: json['id'], token: json['token']);
  }
}
