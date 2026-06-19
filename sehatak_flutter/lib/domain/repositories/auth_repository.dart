import 'package:dartz/dartz.dart';
import '../../core/exceptions/failure.dart';

class User {
  final String id;
  final String email;
  final String name;
  
  User({required this.id, required this.email, required this.name});
}

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> register(String email, String password, String name);
  Future<void> logout();
  Future<User?> getCurrentUser();
}
