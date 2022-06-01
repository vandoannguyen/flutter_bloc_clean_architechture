import 'dart:async';
import 'dart:isolate';

import 'package:baese_flutter_bloc/module/domain/entity/content_model.dart';
import 'package:baese_flutter_bloc/module/domain/usecase/content_usecase.dart';
import 'package:baese_flutter_bloc/module/presenstation/bloc/main/main_view_sate.dart';
import 'package:base_bloc_module/base/cubit/base_cubit.dart';
import 'package:injectable/injectable.dart';

@injectable
class MainBloc extends BaseCubit<MainState> {
  ContentUseCase contentUseCase;
  int couter = 0;
  final StreamController<void> toMain2 = StreamController();

  @factoryMethod
  MainBloc(this.contentUseCase) : super(MainState());

  @override
  void initEventState() {}

  @override
  void closeStream() {
    toMain2.close();
  }

  void testTap() {
    ContentModel? user = state.user?.copyWith();
    if (user == null) {
      user = ContentModel(
          a: "a${DateTime.now().millisecondsSinceEpoch}",
          b: "b${DateTime.now().millisecondsSinceEpoch}");
    } else {
      user = user.copyWith(
          a: "a${DateTime.now().millisecondsSinceEpoch}",
          b: "b${DateTime.now().millisecondsSinceEpoch}");
    }
    print(user.toString());
    emit(state.copyWith(user: user));
    if (state.count! > 3) {
      emit(state.copyWith(count: 0));
      toMain2.sink.add(null);
    } else {
      emit(state.copyWith(count: (state.count ?? 0) + 1));
    }
  }

  void click() {
    // heavyTask("name");
    // compute<String, void>(heavyTask, "name");
    final port = ReceivePort();
    late SendPort sendPort;
    final isolate = Isolate.spawn(heavyTaskSpawn, port.sendPort);
    port.listen((message) {
      if (message is SendPort) {
        sendPort = message;
      } else if (message == "done")
        sendPort.send("message");
      else if (message % 2 == 0) print("receive $message");
    });
    testTap();
  }
//
// heavyTask() {
//   for (int i = 0; i < 50000; i++) {
//     print(i);
//   }
//   return null;
// }

}

FutureOr<void> heavyTask(String message) {
  for (int i = 0; i < 50000; i++) {
    print("$message $i");
  }
}

FutureOr<void> heavyTaskSpawn(SendPort message) async {
  ReceivePort receivePort = ReceivePort();
  receivePort.listen((message) {
    print("listen function $message");
  });
  message.send(receivePort.sendPort);
  for (int i = 0; i < 10; i++) {
    if (i % 5 == 0.0) {
      message.send(i);
      await Future.delayed(Duration(seconds: 1));
    } else {
      await Future.delayed(Duration(milliseconds: 100));
    }
    print("$i");
  }
  message.send("done");
}
