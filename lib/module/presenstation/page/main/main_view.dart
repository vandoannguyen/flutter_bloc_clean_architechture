import 'package:baese_flutter_bloc/di/injection_container.dart';
import 'package:baese_flutter_bloc/module/presenstation/bloc/main/main_view_bloc.dart';
import 'package:baese_flutter_bloc/module/presenstation/bloc/main/main_view_sate.dart';
import 'package:base_bloc_module/views/base_view_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends BaseViewCubit<MainBloc, MainView> {
  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          bloc?.testTap();
        },
        child: Container(
            color: Colors.red,
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BlocBuilder<MainBloc, MainState>(
                    bloc: bloc,
                    builder: (context, state) => Text("${state.count}")),
                BlocBuilder<MainBloc, MainState>(
                    bloc: bloc,
                    buildWhen: (stateIn, stateOut) =>
                        stateIn.value != stateOut.value,
                    builder: (context, state) {
                      print("rebuild${state.count}");
                      return Text(state.value);
                    }),
              ],
            )),
      ),
    );
  }

  @override
  void initEventViewModel() {
    super.initEventViewModel();
  }

  @override
  MainBloc initBloc() {
    return getIt<MainBloc>();
  }
}
