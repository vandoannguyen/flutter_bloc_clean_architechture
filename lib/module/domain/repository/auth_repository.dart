import 'package:baese_flutter_bloc/module/domain/entity/token_info.dart';

abstract class AuthRepository{
  Future<TokenInfo?> refreshToken(String refreshToken);
}