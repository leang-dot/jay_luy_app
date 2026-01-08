class User {
  final String fullName;
  final String email;
  final String password;
  final String profileImage; 

  User({
    required this.fullName,
    required this.email,
    required this.password,
    this.profileImage = 'assets/images/profile.png',
  });

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'email': email,
    'password': password,
    'profileImage': profileImage,
  };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fullName: json['fullName'],
      email: json['email'],
      password: json['password'],
      profileImage: json['profileImage'] ?? 'assets/images/jayluy_logo.png',
    );
  }
}