import 'dart:async';

import 'package:baese_flutter_bloc/module/domain/usecase/content_usecase.dart';
import 'package:base_bloc_module/base/base_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'main2_event.dart';
part 'main2_state.dart';

@injectable
class Main2Bloc extends BaseBloc<Main2Event, Main2State> {
  ContentUseCase contentUseCase;
  @factoryMethod
  Main2Bloc(this.contentUseCase) : super(InitialMain2State());

  @override
  Stream<Main2State> mapEventToState(Main2Event event) async* {
    // TODO: Add your event logic
  }

  @override
  void closeStream() {
    // TODO: implement closeStream
  }

  @override
  void initEventState() {
    // TODO: implement initEventState
  }
}
