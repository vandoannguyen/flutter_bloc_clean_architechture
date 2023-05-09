import 'package:baese_flutter_bloc/module/domain/entity/token_info.dart';
import 'package:baese_flutter_bloc/module/domain/repository/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthUseCase {
  AuthRepository authRepository;

  @singleton
  AuthUseCase(this.authRepository);

  Future<TokenInfo?> refreshToken(String? refreshToken) async {
    if (refreshToken == null) {
      return null;
    }
    return authRepository.refreshToken(refreshToken);
  }
}
