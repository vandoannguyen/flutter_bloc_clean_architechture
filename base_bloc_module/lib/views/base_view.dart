import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../base/bloc/base_bloc.dart';

// ignore: must_be_immutable
abstract class BaseView<BLOC extends BaseBloc> {
  BLOC? bloc;
  late BuildContext contextScreen;

  Widget buildWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    contextScreen = context;
    bloc ??= initBloc();
    return BlocProvider<BLOC>(
      create: (context) => bloc!,
      child: Stack(children: [
        buildWidget(context),
        BlocListener(listener: (ctx, state) {
          initEventViewModel(state);
        })
      ]),
    );
  }

  /// getBloc
  BLOC initBloc();

  /// function allow handle listen which broadcast from bloc
  void initEventViewModel(Object? state);
}
