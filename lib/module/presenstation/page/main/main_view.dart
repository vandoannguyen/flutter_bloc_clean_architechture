import 'package:baese_flutter_bloc/di/injection_container.dart';
import 'package:baese_flutter_bloc/module/presenstation/bloc/main/main_view_bloc.dart';
import 'package:baese_flutter_bloc/module/presenstation/bloc/main/main_view_event.dart';
import 'package:baese_flutter_bloc/module/presenstation/bloc/main/main_view_sate.dart';
import 'package:base_bloc_module/views/base_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends BaseView<MainBloc, MainView> {
  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          bloc?.add(ToMain2Event());
        },
        child: Container(
          color: Colors.red,
          alignment: Alignment.center,
          child: BlocBuilder<MainBloc, MainState>(
              bloc: bloc, builder: (context, state) => Text("${state.count}")),
        ),
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
