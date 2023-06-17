import 'package:baese_flutter_bloc/model/entity/token/token_info.dart';

class SharedPreferenceUtil {
  static Future<TokenInfo?> getTokenInfo() async {
    return TokenInfo(
        accessToken: "accessToken",
        refreshToken: "refreshToken",
        expireAt: 1,
        tokenType: "tokenType");
  }

  static setTokenInfo(TokenInfo newTokenInfo) {}
}
