import 'package:baese_flutter_bloc/common/utils/auth_utils.dart';
import 'package:baese_flutter_bloc/module/domain/usecase/content_usecase.dart';
import 'package:base_bloc_module/base/cubit/base_cubit.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'main2_event.dart';
part 'main2_state.dart';

@injectable
class Main2Bloc extends BaseCubit<Main2State> {
  ContentUseCase contentUseCase;

  @factoryMethod
  Main2Bloc(this.contentUseCase) : super(InitialMain2State());

  @override
  void closeStream() {
    // TODO: implement closeStream
  }

  @override
  void initEventState() {
    // TODO: implement initEventState
  }

  Future<void> loginGoogle() async {
    AuthUtils.instance.loginGoogle();
  }

  void loginFacebook() {
    AuthUtils.instance.loginFacebook();
  }

  void loginApple() {
    AuthUtils.instance.loginApple();
  }
}
