import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'app_sate.dart';

@singleton
class AppBloc extends Cubit<AppState> {
  final StreamController<void> toMain2 = StreamController();

  @factoryMethod
  AppBloc() : super(AppState());

  void testTap() {}
}
