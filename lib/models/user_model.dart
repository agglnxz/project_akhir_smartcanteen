class UserModelGalang {
  final String userId; 
  final String email;
  final String fullName;
  final String password; 

  UserModelGalang({
    required this.userId,
    required this.email,
    required this.fullName,
    required this.password,
  });


  factory UserModelGalang.fromJsonGalang(Map<String, dynamic> json) {
    return UserModelGalang(
      userId: json['user_id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      password: json['password'] as String,
    );
  }

  // Fungsi toJson (Watermark pada fungsi)
  Map<String, dynamic> toJsonGalang() {
    return {
      'user_id': userId,
      'email': email,
      'full_name': fullName,
      'password': password,
    };
  }
}