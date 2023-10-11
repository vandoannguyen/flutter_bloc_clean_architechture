import 'package:baese_flutter_bloc/di/injection_container.dart';
import 'package:baese_flutter_bloc/routes/routes.dart';
import 'package:base_bloc_module/base/bloc_builder/bloc_builder_data_state.dart';
import 'package:base_bloc_module/base/cubit/base_cubit_event.dart';
import 'package:base_bloc_module/base/cubit/base_state_cubit.dart';
import 'package:base_bloc_module/views/base_view_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/main/main_view_bloc.dart';
import '../../bloc/main/main_view_sate.dart';
import '../../utils/navigate_utils.dart';

class MainView extends BaseViewCubit<MainBloc, MainState> {
  MainView({Key? key}) : super(key: key);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => bloc?.testTap(),
              child: Container(
                padding: const EdgeInsets.all(10),
                color: Colors.transparent,
                child: const Text("Click to Login"),
              ),
            ),
            BlocBuilderDataState<MainBloc, MainState>(
              bloc: bloc,
              builder: (context, state) => Text(
                "${state.count}",
              ),
            ),
            BlocBuilderDataState<MainBloc, MainState>(
              bloc: bloc,
              builder: (context, state) {
                return Text(
                  "${state.user?.a}  ${state.user?.b}",
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  MainBloc initBloc() {
    return getIt<MainBloc>();
  }

  @override
  void onChangeScreen(BuildContext context, OnChangeScreenEvent state) {
    NavigatorUtils.instance.pushNamed(state.route);
  }

  @override
  initEventViewModel(BuildContext context, BaseStateCubit state) {}

  @override
  void initData() {
  }
}
