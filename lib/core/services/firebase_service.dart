import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/app_colors.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  late FirebaseFirestore firestore;
  late FirebaseAuth auth;

  Future<void> initialize() async {
    firestore = FirebaseFirestore.instance;
    auth = FirebaseAuth.instance;
    
    // إعدادات Firestore
    await firestore.enablePersistence();
    
    // تعطيل قواعد التحقق من الشبكة مؤقتاً
    firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  // الحصول على المستخدم الحالي
  User? get currentUser => auth.currentUser;

  // تسجيل الدخول
  Future<UserCredential> signInWithEmail(String email, String password) async {
    return await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // إنشاء حساب جديد
  Future<UserCredential> createUserWithEmail(String email, String password) async {
    return await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // تسجيل الخروج
  Future<void> signOut() async {
    await auth.signOut();
  }

  // إرسال رابط إعادة تعيين كلمة المرور
  Future<void> sendPasswordResetEmail(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }
}
