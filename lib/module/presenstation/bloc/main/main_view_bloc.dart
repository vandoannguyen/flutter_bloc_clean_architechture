import 'package:baese_flutter_bloc/base/base_bloc.dart';
import 'package:baese_flutter_bloc/module/presenstation/bloc/main/main_view_event.dart';
import 'package:baese_flutter_bloc/module/presenstation/bloc/main/main_view_sate.dart';
import 'package:injectable/injectable.dart';

@injectable
class MainBloc extends BaseBloc<MainEvent, MainState> {
  @factoryMethod
  MainBloc(MainState initialState) : super(initialState) {}

  @override
  void initEventState() {
    on((event, emit) => null);
  }

  @override
  void closeStream() {}
}
