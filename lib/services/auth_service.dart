import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 현재 로그인한 사용자 스트림
  Stream<User?> get user => _auth.authStateChanges();

  // 회원가입
  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        final user = UserModel(
          uid: result.user!.uid,
          email: email,
          name: name,
          createdAt: DateTime.now(),
        );

        // Firestore에 사용자 정보 저장
        await _firestore.collection('users').doc(result.user!.uid).set(user.toMap());

        return user;
      }
    } catch (e) {
      print('회원가입 에러: $e');
      rethrow;
    }
    return null;
  }

  // 로그인
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        final doc = await _firestore.collection('users').doc(result.user!.uid).get();
        if (doc.exists) {
          return UserModel.fromMap(doc.data()!);
        }
      }
    } catch (e) {
      print('로그인 에러: $e');
      rethrow;
    }
    return null;
  }

  // 로그아웃
  Future<void> signOut() async {
    await _auth.signOut();
  }
} 