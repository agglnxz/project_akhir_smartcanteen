class UserModelGalang {
  final String userId; // NIM/NIK (local)
  final String email;
  final String fullName;

  UserModelGalang({
    required this.userId,
    required this.email,
    required this.fullName,
  });

  factory UserModelGalang.fromJsonGalang(Map<String, dynamic> json) {
    return UserModelGalang(
      userId: json['user_id'] ?? '',
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? '',
    );
  }

  Map<String, dynamic> toJsonGalang() {
    return {
      'user_id': userId,
      'email': email,
      'full_name': fullName,
    };
  }
}
