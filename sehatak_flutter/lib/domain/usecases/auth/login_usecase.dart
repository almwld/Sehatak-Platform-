import '../../repositories/auth_repository.dart';
import '../../../core/exceptions/failure.dart';
import 'package:dartz/dartz.dart';

class LoginUseCase {
  final AuthRepository repository;
  
  LoginUseCase(this.repository);
  
  Future<Either<Failure, AppUser>> execute({
    required String email,
    required String password,
  }) {
    return repository.login(email, password);
  }
}
