import '../module/domain/entity/token_info.dart';
import 'constrance.dart';

class SharedPreferenceUtil {
  static TokenInfo? _tokenInfo;

  static Future<TokenInfo?> getTokenInfo() async {
    if (_tokenInfo != null) {
      return _tokenInfo;
    }

    ///flutter secure storage
    // final secureStorageService = SecureStorageService<TokenInfo>(
    //   SharedPreferenceKey.TokenInfo.name,
    // );
    // final tokenInfo = await secureStorageService.get(
    //     fromJson: (json) => TokenInfo.fromJson(json));
    // _tokenInfo = tokenInfo;
    return _tokenInfo;
  }

  static Future<void> setTokenInfo(TokenInfo tokenInfo) async {
    ///flutter secure storage
    // final secureStorageService = SecureStorageService<TokenInfo>(
    //   SharedPreferenceKey.TokenInfo.name,
    // );
    // await secureStorageService.set(
    //   data: tokenInfo,
    // );
    _tokenInfo = tokenInfo;
  }
}
