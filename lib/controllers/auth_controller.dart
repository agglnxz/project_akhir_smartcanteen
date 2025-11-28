import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';

class AuthControllerFirman {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreServiceGalang _firestore = FirestoreServiceGalang();

  bool isPoliwangiEmail(String email) => email.toLowerCase().endsWith('@poliwangi.ac.id');

  /// Register: buat akun di Firebase Auth lalu simpan profil di Firestore (docId = uid)
  Future<String> registerUser({
    required String email,
    required String password,
    required String fullName,
    required String userIdFromInput,
  }) async {
    if (!isPoliwangiEmail(email)) {
      throw Exception('Gunakan email @poliwangi.ac.id untuk registrasi.');
    }

    // Cek NIM/NIK unik (opsional)
    final exists = await _firestore.checkUserIdExists(userIdFromInput.trim());
    if (exists) {
      throw Exception('NIM/NIK sudah terdaftar. Gunakan NIM/NIK lain atau hubungi admin.');
    }

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final uid = userCredential.user!.uid;

      final profile = UserModelGalang(
        userId: userIdFromInput.trim(),
        email: email.trim(),
        fullName: fullName.trim(),
      );

      await _firestore.saveUserToFirestore(uid: uid, user: profile);

      return uid;
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'weak-password':
          message = 'Password terlalu lemah. Minimal 6 karakter.';
          break;
        case 'email-already-in-use':
          message = 'Email sudah terdaftar. Silakan login.';
          break;
        default:
          message = 'Registrasi gagal. Kode: ${e.code}';
      }
      throw Exception(message);
    } catch (e) {
      throw Exception('Registrasi gagal: ${e.toString()}');
    }
  }

  /// Login: sign in via Firebase Auth (mengembalikan User)
  Future<User?> loginUser({
    required String email,
    required String password,
  }) async {
    if (!isPoliwangiEmail(email)) {
      throw Exception('Email harus @poliwangi.ac.id');
    }
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
        case 'wrong-password':
          message = 'Email atau password salah.';
          break;
        default:
          message = 'Login gagal. Kode: ${e.code}';
      }
      throw Exception(message);
    } catch (e) {
      throw Exception('Login gagal: ${e.toString()}');
    }
  }

  Future<void> signOut() async => _auth.signOut();
}
