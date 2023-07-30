// ignore_for_file: must_be_immutable

import 'package:base_bloc_module/base/cubit/base_cubit.dart';
import 'package:base_bloc_module/base/cubit/base_cubit_event.dart';
import 'package:base_bloc_module/base/cubit/base_data_state_cubit.dart';
import 'package:base_bloc_module/base/cubit/base_state_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseViewCubit<CUBIT extends BaseCubit<STATE>,
STATE extends BaseStateCubit> extends StatelessWidget {
  CUBIT? _bloc;

  BaseViewCubit({Key? key}) : super(key: key);

  Widget buildWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    _bloc ??= initBloc();
    return BlocProvider<CUBIT>(
      create: (context) => _bloc!,
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

  initEventViewModel(BuildContext context, BaseStateCubit state);

  /// getBloc
  CUBIT initBloc();

  CUBIT get bloc => _bloc!;

  void _showLoading(BuildContext context, OnLoadingEvent state) {}

  void _showMessage(BuildContext context, OnMessageEvent state) {}

  void onChangeScreen(BuildContext context, OnChangeScreenEvent state);
}