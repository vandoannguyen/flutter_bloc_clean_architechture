import 'package:base_bloc_module/index.dart';
import 'package:injectable/injectable.dart';
import 'register_account_state.dart';

@injectable
class RegisterAccountBloc extends BaseCubit<RegisterAccountState> {
  RegisterAccountBloc() : super( RegisterAccountState());
}
