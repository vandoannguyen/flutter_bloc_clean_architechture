import 'package:injectable/injectable.dart';
import '../../../../core/error/failures/failure.dart';
import '../../../../core/error/result.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

@injectable
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Result<UserEntity>> call({
    required String id,
    required String password,
  }) async {
    if (id.isEmpty) {
      return Result.failure(
        const Failure.validation(message: 'ID cannot be empty'),
      );
    }
    if (password.isEmpty) {
      return Result.failure(
        const Failure.validation(message: 'Password cannot be empty'),
      );
    }
    if (password.length < 8) {
      return Result.failure(
        const Failure.validation(message: 'Password must be at least 8 characters'),
      );
    }
    return await _repository.login(id: id, password: password);
  }
}
