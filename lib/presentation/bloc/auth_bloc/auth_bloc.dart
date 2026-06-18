import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/services/firebase_service.dart';

// Events
abstract class AuthEvent {}

class AppStarted extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  final bool isDoctor;

  LoginRequested({
    required this.email,
    required this.password,
    this.isDoctor = false,
  });
}

class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final bool isDoctor;

  RegisterRequested({
    required this.email,
    required this.password,
    required this.name,
    this.isDoctor = false,
  });
}

class LogoutRequested extends AuthEvent {}

class ResetPasswordRequested extends AuthEvent {
  final String email;
  ResetPasswordRequested(this.email);
}

// States
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthSuccess extends AuthState {
  final String message;
  AuthSuccess(this.message);
}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseService _firebaseService = FirebaseService();

  AuthBloc() : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
  }

  void _onAppStarted(AppStarted event, Emitter<AuthState> emit) {
    final user = _firebaseService.currentUser;
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final credential = await _firebaseService.signInWithEmail(
        event.email,
        event.password,
      );
      emit(AuthAuthenticated(credential.user!));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_getErrorMessage(e)));
    } catch (e) {
      emit(AuthError('حدث خطأ غير متوقع'));
    }
  }

  Future<void> _onRegisterRequested(RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final credential = await _firebaseService.createUserWithEmail(
        event.email,
        event.password,
      );
      
      // تحديث اسم المستخدم
      await credential.user?.updateDisplayName(event.name);
      
      // حفظ بيانات المستخدم في Firestore
      await FirebaseService().firestore.collection('users').doc(credential.user!.uid).set({
        'name': event.name,
        'email': event.email,
        'isDoctor': event.isDoctor,
        'createdAt': FieldValue.serverTimestamp(),
      });

      emit(AuthAuthenticated(credential.user!));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_getErrorMessage(e)));
    } catch (e) {
      emit(AuthError('حدث خطأ غير متوقع'));
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _firebaseService.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError('حدث خطأ أثناء تسجيل الخروج'));
    }
  }

  Future<void> _onResetPasswordRequested(ResetPasswordRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _firebaseService.sendPasswordResetEmail(event.email);
      emit(AuthSuccess('تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني'));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_getErrorMessage(e)));
    } catch (e) {
      emit(AuthError('حدث خطأ غير متوقع'));
    }
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'المستخدم غير موجود';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحة';
      case 'email-already-in-use':
        return 'البريد الإلكتروني مستخدم بالفعل';
      case 'invalid-email':
        return 'البريد الإلكتروني غير صحيح';
      case 'weak-password':
        return 'كلمة المرور ضعيفة جداً';
      default:
        return e.message ?? 'حدث خطأ';
    }
  }
}
