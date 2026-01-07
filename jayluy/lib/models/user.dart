class User {
  final String fullName;
  final String email;
  final String password; // In a real app, never store raw passwords!
  final String profileImage;

  User({
    required this.fullName,
    required this.email,
    required this.password,
    this.profileImage = 'assets/images/jayluy_logo.png',
  });
}