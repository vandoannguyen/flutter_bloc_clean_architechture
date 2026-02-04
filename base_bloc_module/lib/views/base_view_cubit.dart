// ignore_for_file: must_be_immutable

import 'package:base_bloc_module/base/cubit/base_cubit.dart';
import 'package:base_bloc_module/base/cubit/base_cubit_event.dart';
import 'package:base_bloc_module/base/cubit/base_state_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'base_view_cubit_method.dart';

abstract class BaseViewCubit<CUBIT extends BaseCubit<STATE>,
STATE extends BaseStateCubit, EVENT extends BaseCubitEvent>
    extends StatelessWidget with BaseViewCubitMethod<CUBIT, EVENT> {
  BaseViewCubit({super.key}) {
    bloc = initBloc();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CUBIT>(
      create: (context) {
        initData();
        return bloc!;
      },
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
          if (state is EVENT) initEventViewModel(context, state);
        },
        listenWhen: (old, newState) => newState is BaseCubitEvent,
        child: buildWidget(context),
      ),
    );
  }
}
