import 'package:injectable/injectable.dart';
import '../../../../core/error/failures/failure.dart';
import '../../../../core/error/result.dart';
import '../../../../core/utils/extensions/string_extensions.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for user login.
/// 
/// This use case handles the business logic for user authentication,
/// including input validation and calling the repository.
@injectable
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  /// Executes the login use case.
  /// 
  /// [email] - User's email address
  /// [password] - User's password
  /// 
  /// Returns [Result<UserEntity>] containing either the authenticated user
  /// or a validation/authentication failure.
  Future<Result<UserEntity>> call({
    required String email,
    required String password,
  }) async {
    // Validation logic
    if (email.isEmpty) {
      return Result.failure(
        const Failure.validation(message: 'Email cannot be empty'),
      );
    }

    if (!email.isValidEmail) {
      return Result.failure(
        const Failure.validation(message: 'Invalid email format'),
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

    // Call repository
    return await _repository.login(email: email, password: password);
  }
}
