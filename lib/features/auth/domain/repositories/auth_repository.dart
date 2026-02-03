import '../../../../core/error/result.dart';
import '../entities/user_entity.dart';
import '../entities/token/token_entity.dart';

/// Authentication repository interface.
/// 
/// This interface is defined in the domain layer and must not depend
/// on any data layer implementations.
/// 
/// All methods return Result<T> for type-safe error handling.
abstract class AuthRepository {
  /// Logs in a user with email and password.
  /// 
  /// [email] - User's email address
  /// [password] - User's password
  /// 
  /// Returns [Result<UserEntity>] containing the authenticated user or an error.
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  });

  /// Logs out the current user.
  /// 
  /// Returns [Result<void>] indicating success or failure.
  Future<Result<void>> logout();

  /// Gets the currently authenticated user.
  /// 
  /// Returns [Result<UserEntity?>] containing the user if logged in, null otherwise.
  Future<Result<UserEntity?>> getCurrentUser();

  /// Refreshes the authentication token.
  /// 
  /// [refreshToken] - The refresh token to use
  /// Returns [Result<TokenEntity>] containing new tokens or an error.
  Future<Result<TokenEntity>> refreshToken(String refreshToken);
}
