import 'package:base_flutter_bloc/model/entity/token/token_info.dart';

class SharedPreferenceUtil {
  static TokenInfo? tokenInfo;
  static Future<TokenInfo?> getTokenInfo() async {
    return tokenInfo;
  }

  static setTokenInfo(TokenInfo? newTokenInfo) {
    tokenInfo = newTokenInfo;
  }
}
