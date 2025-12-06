import 'package:crypto/crypto.dart';
import 'dart:convert';

class UserModelGalang {
  final String userId; // NIM/NIK (local)
  final String email;
  final String fullName;
  final String passwordHash;   // TAMBAHAN
  final String role;           // TAMBAHAN

  UserModelGalang({
    required this.userId,
    required this.email,
    required this.fullName,
    required this.passwordHash,
    required this.role,
  });

  factory UserModelGalang.fromJsonGalang(Map<String, dynamic> json) {
    return UserModelGalang(
      userId: json['user_id'] ?? '',
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? '',
      passwordHash: json['password_hash'] ?? '',
      role: json['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toJsonGalang() {
    return {
      'user_id': userId,
      'email': email,
      'full_name': fullName,
      'password_hash': passwordHash,
      'role': role,
    };
  }

  /// Fungsi untuk Hash Password (SHA-256)
  static String generateHash(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }
}