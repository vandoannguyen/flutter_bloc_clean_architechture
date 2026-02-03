import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../repositories/auth_repository.dart';

/// Use case for user logout.
@injectable
class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  /// Executes the logout use case.
  /// 
  /// Returns [Result<void>] indicating success or failure.
  Future<Result<void>> call() async {
    return await _repository.logout();
  }
}
