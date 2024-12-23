import 'package:base_flutter_bloc/domain/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginUseCase{
  final UserRepository _userRepository;
  @factoryMethod
  LoginUseCase(this._userRepository);
}
