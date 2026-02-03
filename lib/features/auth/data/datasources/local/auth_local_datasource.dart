import 'package:base_flutter_bloc/features/auth/data/models/token_model.dart';
import 'package:base_flutter_bloc/features/auth/data/models/user_model.dart';
import 'package:injectable/injectable.dart';

/// Local data source for authentication data (SharedPreferences, etc.).
@injectable
abstract class AuthLocalDataSource {
  /// Saves authentication token.
  Future<void> saveToken(TokenModel token);

  /// Gets saved authentication token.
  Future<TokenModel?> getToken();

  /// Removes authentication token.
  Future<void> removeToken();

  /// Saves current user.
  Future<void> saveUser(UserModel user);

  /// Gets saved current user.
  Future<UserModel?> getUser();

  /// Removes current user.
  Future<void> removeUser();
}
