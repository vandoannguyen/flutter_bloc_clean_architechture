import 'package:base_bloc_module/index.dart';
import 'package:base_flutter_bloc/bloc/home/home_bloc.dart';
import 'package:base_flutter_bloc/bloc/home/home_state.dart';
import 'package:base_flutter_bloc/core/di/injection_container.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState
    extends BaseViewCubitState<HomeBloc, HomeState, HomeEvent, HomeScreen> {
  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      body: BlocBuilderDataState<HomeBloc, HomeState>(
        builder: (BuildContext context, HomeState state) {
          return Center(
            child: Text(
              state.count.toString(),
            ),
          );
        },
      ),
      floatingActionButton: ElevatedButton(
        onPressed: bloc?.clickAdd,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  HomeBloc initBloc() {
    return getIt<HomeBloc>();
  }

  @override
  void initData() {}

  @override
  void initEventViewModel(BuildContext context, HomeEvent state) {}
}
