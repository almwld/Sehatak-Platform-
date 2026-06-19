import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Events
abstract class AuthEvent {}
class AppStarted extends AuthEvent {}
class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  final bool isDoctor;
  LoginRequested({required this.email, required this.password, this.isDoctor = false});
}
class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final bool isDoctor;
  RegisterRequested({required this.email, required this.password, required this.name, this.isDoctor = false});
}
class LogoutRequested extends AuthEvent {}

// States
abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {}
class AuthUnauthenticated extends AuthState {}
class AuthSuccess extends AuthState {
  final String message;
  AuthSuccess(this.message);
}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthBloc() : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final user = _auth.currentUser;
    if (user != null) {
      emit(AuthAuthenticated());
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      if (userCredential.user != null) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthError('فشل تسجيل الدخول'));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? 'خطأ في تسجيل الدخول'));
    } catch (e) {
      emit(AuthError('حدث خطأ غير متوقع'));
    }
  }

  Future<void> _onRegisterRequested(RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      
      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'name': event.name,
          'email': event.email,
          'isDoctor': event.isDoctor,
          'createdAt': FieldValue.serverTimestamp(),
        });
        emit(AuthSuccess('تم إنشاء الحساب بنجاح'));
        emit(AuthAuthenticated());
      } else {
        emit(AuthError('فشل إنشاء الحساب'));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? 'خطأ في إنشاء الحساب'));
    } catch (e) {
      emit(AuthError('حدث خطأ غير متوقع'));
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    await _auth.signOut();
    emit(AuthUnauthenticated());
  }
}
