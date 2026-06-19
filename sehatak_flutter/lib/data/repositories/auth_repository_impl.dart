import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/exceptions/failure.dart';
import '../../core/services/firebase/firebase_service.dart';
import '../../core/di/injection.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseService _firebaseService = sl<FirebaseService>();

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final userCredential = await _firebaseService.auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final user = userCredential.user;
      if (user != null) {
        return Right(User(
          id: user.uid,
          email: user.email ?? '',
          name: user.displayName ?? 'مستخدم',
        ));
      } else {
        return Left(Failure('فشل تسجيل الدخول'));
      }
    } on FirebaseAuthException catch (e) {
      return Left(Failure(_getAuthErrorMessage(e.code)));
    } catch (e) {
      return Left(Failure('حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, User>> register(String email, String password, String name) async {
    try {
      final userCredential = await _firebaseService.auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName(name);
        return Right(User(
          id: user.uid,
          email: user.email ?? '',
          name: name,
        ));
      } else {
        return Left(Failure('فشل إنشاء الحساب'));
      }
    } on FirebaseAuthException catch (e) {
      return Left(Failure(_getAuthErrorMessage(e.code)));
    } catch (e) {
      return Left(Failure('حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseService.auth.signOut();
  }

  @override
  Future<User?> getCurrentUser() async {
    final user = _firebaseService.auth.currentUser;
    if (user != null) {
      return User(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? 'مستخدم',
      );
    }
    return null;
  }

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'المستخدم غير موجود';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحة';
      case 'email-already-in-use':
        return 'البريد الإلكتروني مستخدم مسبقاً';
      case 'invalid-email':
        return 'البريد الإلكتروني غير صحيح';
      case 'weak-password':
        return 'كلمة المرور ضعيفة جداً';
      default:
        return 'حدث خطأ في المصادقة';
    }
  }
}
