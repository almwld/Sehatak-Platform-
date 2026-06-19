import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkService {
  Future<bool> hasInternet();
  Dio get dio;
}

class NetworkServiceImpl implements NetworkService {
  late final Dio _dio;
  final Connectivity _connectivity = Connectivity();

  NetworkServiceImpl() {
    _dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));
    
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // إضافة header للتطبيق
        options.headers['X-App-Version'] = '2.0.0';
        options.headers['X-Platform'] = 'flutter';
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (error, handler) {
        return handler.next(error);
      },
    ));
  }

  @override
  Future<bool> hasInternet() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  @override
  Dio get dio => _dio;
}
