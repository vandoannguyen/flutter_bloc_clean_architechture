import 'package:baese_flutter_bloc/bloc/main2/main2_bloc.dart';
import 'package:baese_flutter_bloc/bloc/main2/main2_event.dart';
import 'package:baese_flutter_bloc/bloc/main2/main2_state.dart';
import 'package:baese_flutter_bloc/di/injection_container.dart';
import 'package:base_bloc_module/index.dart';
import 'package:flutter/material.dart';

class MainView2 extends StatefulWidget {
  const MainView2({Key? key}) : super(key: key);

  @override
  State<MainView2> createState() => _MainView2State();
}

class _MainView2State
    extends BaseViewCubitState<Main2Bloc, Main2State, MainView2> {
  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      body: Container(
        child: BlocBuilderDataState<Main2Bloc, Main2State>(
          builder: (BuildContext context, Main2State state) {
            return Container();
          },
        ),
      ),
    );
  }

  @override
  Main2Bloc initBloc() {
    return getIt<Main2Bloc>();
  }

  @override
  void initData() {
    bloc?.loadData();
  }

  @override
  void initEventViewModel(BuildContext context, BaseCubitEvent state) {
    if (state is Main2ViewEvent) {
      state.when(getData: () {}, showMessage: () {});
    }
  }
}
