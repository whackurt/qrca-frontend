class Clerk {
  String username;
  String password;

  Clerk({required this.username, required this.password});

  factory Clerk.fromJson(Map<String, dynamic> json) {
    return Clerk(
      username: json['username'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}
