import 'package:baese_flutter_bloc/module/domain/entity/token_info.dart';
import 'package:baese_flutter_bloc/module/domain/repository/content_repository.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repository/auth_repository.dart';

@singleton
class AuthRemoteDataSource implements AuthRepository {
  @factoryMethod
  AuthRemoteDataSource();

  @override
  Future<TokenInfo?> refreshToken(String refreshToken) {
    // TODO: implement refreshToken
    throw UnimplementedError();
  }
}
