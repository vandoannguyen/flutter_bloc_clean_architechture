import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for getting the current authenticated user.
@injectable
class GetCurrentUserUseCase {
  final AuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  /// Executes the get current user use case.
  /// 
  /// Returns [Result<UserEntity?>] containing the user if logged in, null otherwise.
  Future<Result<UserEntity?>> call() async {
    return await _repository.getCurrentUser();
  }
}
