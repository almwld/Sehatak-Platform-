import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/services/firebase_service.dart';
import 'core/themes/theme_manager.dart';
import 'presentation/bloc/auth_bloc/auth_bloc.dart';
import 'presentation/bloc/theme_bloc/theme_bloc.dart';
import 'presentation/screens/auth/splash_screen.dart';
import 'core/services/medical_ai_local.dart';

void main() {
  // ✅ تشغيل التطبيق فوراً دون انتظار
  WidgetsFlutterBinding.ensureInitialized();
  
  // ✅ تقييد اتجاه الشاشة
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // ✅ تشغيل التطبيق فوراً
  runApp(const MyApp());

  // 🔥 تهيئة Firebase في الخلفية (لا تؤثر على بدء التطبيق)
  _initializeServicesInBackground();
}

void _initializeServicesInBackground() {
  // تشغيل التهيئة في الخلفية بدون انتظار
  Future.microtask(() async {
    try {
      // تهيئة Firebase
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      
      // تهيئة الخدمات
      await FirebaseService().initialize();
      
      // اختبار الذكاء المحلي
      final medicalAI = MedicalAILocal();
      debugPrint('🧠 الذكاء المحلي جاهز: ${medicalAI.analyzeSymptoms("صداع")}');
      
      debugPrint('✅ تم تهيئة Firebase في الخلفية بنجاح');
    } catch (e) {
      debugPrint('⚠️ تهيئة Firebase في الخلفية: $e (التطبيق يعمل في وضع Offline)');
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc()..add(AppStarted()),
        ),
        BlocProvider<ThemeBloc>(
          create: (_) => ThemeBloc(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'صحتك',
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: child!,
              );
            },
            theme: ThemeManager.lightTheme,
            darkTheme: ThemeManager.darkTheme,
            themeMode: state is ThemeLoadedState ? state.themeMode : ThemeMode.light,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
