import 'package:get_it/get_it.dart';
import '../services/firebase/firebase_service.dart';
import '../services/network/network_service.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  // ==============================================
  // 🔥 Firebase Services
  // ==============================================
  sl.registerLazySingleton<FirebaseService>(() => FirebaseServiceImpl());
  
  // ==============================================
  // 🌐 Network Services
  // ==============================================
  sl.registerLazySingleton<NetworkService>(() => NetworkServiceImpl());
  
  // ==============================================
  // 📦 Repositories
  // ==============================================
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
}
