import 'package:injectable/injectable.dart';
import '../../../../core/error/failures/failure.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/token/token_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../models/user_model.dart';
import '../models/token_model.dart';
import '../models/login_request.dart';
import '../models/refresh_token_request.dart';

/// Implementation of AuthRepository.
/// 
/// This class implements the domain repository interface and handles
/// data conversion between models and entities.
@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

  @override
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final request = LoginRequest(email, password);
      final response = await _remoteDataSource.login(request);

      // Extract token from response
      if (response['token'] != null && response['refreshToken'] != null) {
        final token = TokenModel(
          accessToken: response['token'],
          refreshToken: response['refreshToken'],
        );
        await _localDataSource.saveToken(token);
      }

      // Extract user from response (if available)
      // For now, create a basic user entity
      final user = UserModel(
        id: response['userId']?.toString() ?? '0',
        email: email,
        name: response['name'],
      );
      await _localDataSource.saveUser(user);

      return Result.success(user.toEntity());
    } catch (e) {
      return Result.failure(
        Failure.unknown(
          message: 'Login failed: ${e.toString()}',
          error: e,
        ),
      );
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _localDataSource.removeToken();
      await _localDataSource.removeUser();
      return const Result.success(null);
    } catch (e) {
      return Result.failure(
        Failure.unknown(
          message: 'Logout failed: ${e.toString()}',
          error: e,
        ),
      );
    }
  }

  @override
  Future<Result<UserEntity?>> getCurrentUser() async {
    try {
      final userModel = await _localDataSource.getUser();
      if (userModel != null) {
        return Result.success(userModel.toEntity());
      }
      return const Result.success(null);
    } catch (e) {
      return Result.failure(
        Failure.unknown(
          message: 'Get current user failed: ${e.toString()}',
          error: e,
        ),
      );
    }
  }

  @override
  Future<Result<TokenEntity>> refreshToken(String refreshToken) async {
    try {
      final request = RefreshTokenRequest(refreshToken);
      final response = await _remoteDataSource.refreshToken(request);

      final token = TokenModel(
        accessToken: response['token'],
        refreshToken: response['refreshToken'],
        expireAt: response['expireAt'],
      );
      await _localDataSource.saveToken(token);

      return Result.success(token.toEntity());
    } catch (e) {
      return Result.failure(
        Failure.authentication(
          message: 'Token refresh failed: ${e.toString()}',
        ),
      );
    }
  }
}
