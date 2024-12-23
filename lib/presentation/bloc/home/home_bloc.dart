import 'package:base_bloc_module/index.dart';
import 'package:base_flutter_bloc/presentation/bloc/home/home_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeBloc extends BaseCubit<HomeState> {
  @factoryMethod
  HomeBloc() : super(HomeState());

  void clickAdd() {
    emit(
      dataState.copyWith(
        count: dataState.count + 1,
      ),
    );
  }
}
