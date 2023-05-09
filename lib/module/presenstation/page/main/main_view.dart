import 'package:baese_flutter_bloc/common/utils/navigate_utils.dart';
import 'package:baese_flutter_bloc/di/injection_container.dart';
import 'package:baese_flutter_bloc/module/presenstation/bloc/main/main_view_bloc.dart';
import 'package:baese_flutter_bloc/module/presenstation/bloc/main/main_view_sate.dart';
import 'package:baese_flutter_bloc/routes/routes.dart';
import 'package:base_bloc_module/views/base_view_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainView extends BaseViewCubit<MainBloc> {
  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                NavigateUtils.instance.pushNamed(CommonRoutes.MAIN2);
              },
              child: Container(
                padding: EdgeInsets.all(10),
                color: Colors.transparent,
                child: Text("Click to Login"),
              ),
            ),
            BlocListener<MainBloc, MainState>(listener: (ctx, state) {

            }),
            BlocBuilder<MainBloc, MainState>(
                bloc: bloc,
                builder: (context, state) => Text("${state.count}")),
            BlocBuilder<MainBloc, MainState>(
                bloc: bloc,
                builder: (context, state) {
                  return Text("${state.user?.a}  ${state.user?.b}");
                }),
          ],
        ),
      ),
    );
  }

  @override
  void initEventViewModel(state) {
    if(state is NavigateMainState) {
      NavigateUtils.instance.pushNamed(CommonRoutes.MAIN2);
    }
  }

  @override
  MainBloc initBloc() {
    return getIt<MainBloc>();
  }
}
