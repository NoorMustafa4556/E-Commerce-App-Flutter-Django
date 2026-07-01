class User {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String? profilePic;
  final String token;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.profilePic,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json, String token) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      profilePic: json['profile_pic'],
      token: token,
    );
  }
}
