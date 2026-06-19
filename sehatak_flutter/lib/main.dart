import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';
import 'core/services/firebase/firebase_service.dart';
import 'presentation/bloc/theme/theme_bloc.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/themes/app_theme.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'domain/usecases/auth/login_usecase.dart';
import 'domain/usecases/auth/register_usecase.dart';
import 'domain/usecases/auth/logout_usecase.dart';
import 'data/repositories/auth_repository_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp();
  await configureDependencies();
  await sl<FirebaseService>().initialize();
  
  runApp(const SehatakApp());
}

class SehatakApp extends StatelessWidget {
  const SehatakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeBloc()),
        BlocProvider(
          create: (_) => AuthBloc(
            loginUseCase: LoginUseCase(AuthRepositoryImpl()),
            registerUseCase: RegisterUseCase(AuthRepositoryImpl()),
            logoutUseCase: LogoutUseCase(AuthRepositoryImpl()),
          ),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'صحتك',
            debugShowCheckedModeBanner: false,
            theme: state is ThemeDark ? AppTheme.darkTheme : AppTheme.lightTheme,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
