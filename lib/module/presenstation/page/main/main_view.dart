import 'package:baese_flutter_bloc/base/base_view.dart';
import 'package:baese_flutter_bloc/module/presenstation/bloc/main/main_view_bloc.dart';
import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends BaseView<MainBloc, MainView> {
  @override
  Widget buildWidget(BuildContext context) {
    return Container();
  }

  @override
  void initEventViewModel() {}
}
