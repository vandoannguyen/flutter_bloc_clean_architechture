import 'package:baese_flutter_bloc/di/injection_container.dart';
import 'package:baese_flutter_bloc/module/presenstation/bloc/main2/main2_bloc.dart';
import 'package:base_bloc_module/views/base_view.dart';
import 'package:flutter/material.dart';

class Main2View extends StatefulWidget {
  const Main2View({Key? key}) : super(key: key);

  @override
  _Main2ViewState createState() => _Main2ViewState();
}

class _Main2ViewState extends BaseView<Main2Bloc, Main2View> {
  @override
  Widget buildWidget(BuildContext context) {
    return Container(
      color: Colors.orange,
    );
  }

  @override
  void initEventViewModel() {}

  @override
  Main2Bloc initBloc() {
    return getIt<Main2Bloc>();
  }
}
