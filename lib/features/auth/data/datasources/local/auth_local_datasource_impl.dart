import 'package:base_flutter_bloc/features/auth/data/models/token_model.dart';
import 'package:base_flutter_bloc/features/auth/data/models/user_model.dart';
import 'package:base_flutter_bloc/model/entity/token/token_info.dart';
import 'package:base_flutter_bloc/shared/utils/share_preference_utils.dart';
import 'package:injectable/injectable.dart';
import 'auth_local_datasource.dart';

/// Implementation of AuthLocalDataSource using SharedPreferences.
@Injectable(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  @override
  Future<void> saveToken(TokenModel token) async {
    // TODO: Implement using SharedPreferenceUtil
    // For now, using existing implementation
    SharedPreferenceUtil.setTokenInfo(
      TokenInfo(
        accessToken: token.accessToken,
        refreshToken: token.refreshToken,
        expireAt: token.expireAt,
        tokenType: token.tokenType,
      ),
    );
  }

  @override
  Future<TokenModel?> getToken() async {
    final tokenInfo = await SharedPreferenceUtil.getTokenInfo();
    if (tokenInfo == null) return null;
    return TokenModel(
      accessToken: tokenInfo.accessToken,
      refreshToken: tokenInfo.refreshToken,
      expireAt: tokenInfo.expireAt,
      tokenType: tokenInfo.tokenType,
    );
  }

  @override
  Future<void> removeToken() async {
    SharedPreferenceUtil.setTokenInfo(null);
  }

  @override
  Future<void> saveUser(UserModel user) async {
    // TODO: Implement user storage
  }

  @override
  Future<UserModel?> getUser() async {
    // TODO: Implement user retrieval
    return null;
  }

  @override
  Future<void> removeUser() async {
    // TODO: Implement user removal
  }
}
