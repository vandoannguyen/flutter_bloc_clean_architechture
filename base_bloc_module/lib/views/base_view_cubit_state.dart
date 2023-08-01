// ignore_for_file: must_be_immutable

import 'package:base_bloc_module/base/cubit/base_cubit.dart';
import 'package:base_bloc_module/base/cubit/base_cubit_event.dart';
import 'package:base_bloc_module/base/cubit/base_state_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'base_view_cubit_method.dart';

abstract class BaseViewCubitState<CUBIT extends BaseCubit<STATE>,
        STATE extends BaseStateCubit, VIEW extends StatefulWidget>
    extends State<VIEW> with BaseViewCubitMethod<CUBIT> {
  @override
  void initState() {
    super.initState();
    bloc ??= initBloc();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CUBIT>(
      create: (context) => bloc!,
      child: BlocListener<CUBIT, BaseStateCubit>(
        listener: (ctx, state) {
          if (state is OnLoadingEvent) {
            showLoading(context, state);
            return;
          }
          if (state is OnMessageEvent) {
            showMessage(context, state);
            return;
          }
          if (state is OnChangeScreenEvent) {
            onChangeScreen(context, state);
            return;
          }
          initEventViewModel(context, state as BaseCubitEvent);
        },
        listenWhen: (old, newState) => newState is BaseCubitEvent,
        child: buildWidget(context),
      ),
    );
  }
}
