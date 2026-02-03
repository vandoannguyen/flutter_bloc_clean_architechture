import 'package:base_bloc_module/index.dart';
import 'package:flutter/material.dart';
import '../../../../core/di/injection_container.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';

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
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: BlocBuilderDataState<HomeBloc, HomeState>(
        bloc: bloc,
        builder: (BuildContext context, HomeState state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Count: ${state.counter.count}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: bloc?.increment,
                  child: const Text('Increment'),
                ),
              ],
            ),
          );
        },
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
  void initEventViewModel(BuildContext context, HomeEvent state) {
    state.when(
      increment: () {
        // Handle increment event if needed
      },
    );
  }
}
