class User {
  final String fullName;
  final String email;
  final String password;
  // We won't strictly use profileImage for logic yet, but good to have in model
  final String profileImage; 

  User({
    required this.fullName,
    required this.email,
    required this.password,
    this.profileImage = 'assets/images/jayluy_logo.png',
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