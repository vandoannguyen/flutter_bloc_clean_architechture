import 'package:base_bloc_module/views/widgets/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../base/bloc/base_bloc.dart';

// ignore: must_be_immutable
abstract class BaseView<BLOC extends BaseBloc, STATE extends StatefulWidget>
    extends State<STATE> {
  BLOC? bloc;
  late BuildContext contextScreen;

  Widget buildWidget(BuildContext context);

  @override
  void initState() {
    super.initState();
    bloc ??= initBloc();
  }

  @override
  Widget build(BuildContext context) {
    contextScreen = context;
    return BlocProvider<BLOC>(
      create: (context) => bloc!,
      child: BlocListener<CUBIT, BaseCubitEvent>(
        listener: (ctx, state) {
          if (state is OnLoadingEvent) {
            _showLoading(context, state);
            return;
          }
          if (state is OnMessageEvent) {
            _showMessage(context, state);
            return;
          }
          if (state is OnChangeScreenEvent) {
            onChangeScreen(context, state);
            return;
          }
          initEventViewModel(context, state);
        },
        listenWhen: (old, newState) => newState is BaseCubitEvent,
        child: buildWidget(context),
      ),
    );
  }

  @override
  void dispose() {
    bloc?.close();
    super.dispose();
  }

  /// getBloc
  BLOC initBloc();

  /// function allow handle listen which broadcast from bloc
  void initEventViewModel(BuildContext context, BaseStateCubit state);

  void _showLoading(BuildContext context, OnLoadingEvent state) {}

  void _showMessage(BuildContext context, OnMessageEvent state) {}

  void onChangeScreen(BuildContext context, OnChangeScreenEvent state);
}
