import 'package:baese_flutter_bloc/module/data/network/content_remote_data_source.dart';
import 'package:baese_flutter_bloc/module/domain/entity/token_info.dart';
import 'package:baese_flutter_bloc/module/domain/repository/content_repository.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repository/auth_repository.dart';

@Singleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  ContentRemoteDataSource dataSource;

  @factoryMethod
  AuthRepositoryImpl(this.dataSource);

  @override
  Future<TokenInfo?> refreshToken(String refreshToken) {
    // TODO: implement refreshToken
    throw UnimplementedError();
  }
}
