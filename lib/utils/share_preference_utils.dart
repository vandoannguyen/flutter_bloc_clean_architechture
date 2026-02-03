import 'package:base_flutter_bloc/features/auth/data/models/token_model.dart';

class SharedPreferenceUtil {
  static TokenModel? tokenInfo;
  static Future<TokenModel?> getTokenInfo() async {
    return tokenInfo;
  }

  static void setTokenInfo(TokenModel? newTokenInfo) {
    tokenInfo = newTokenInfo;
  }
}
