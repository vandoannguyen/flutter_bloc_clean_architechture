import 'package:base_bloc_module/index.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/increment_counter_usecase.dart';
import 'home_state.dart';

@injectable
class HomeBloc extends BaseCubit<HomeState> {
  final IncrementCounterUseCase _incrementCounterUseCase;

  HomeBloc(this._incrementCounterUseCase) : super( HomeState());

  void increment() {
    final newCounter = _incrementCounterUseCase(dataState.counter);
    emit(dataState.copyWith(counter: newCounter));
  }
}
