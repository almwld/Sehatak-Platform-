import '../../repositories/auth_repository.dart';
import '../../../core/exceptions/failure.dart';
import 'package:dartz/dartz.dart';

class RegisterUseCase {
  final AuthRepository repository;
  
  RegisterUseCase(this.repository);
  
  Future<Either<Failure, User>> execute({
    required String email,
    required String password,
    required String name,
  }) {
    return repository.register(email, password, name);
  }
}
