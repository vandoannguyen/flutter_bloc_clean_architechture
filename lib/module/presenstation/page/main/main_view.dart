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
      body: SafeArea(
        child: GestureDetector(
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
                    builder: (context, state) => Text("${state.count}")),
                BlocBuilder<MainBloc, MainState>(
                  buildWhen: (stateIn, stateOut) =>
                      stateIn.value != stateOut.value,
                  builder: (context, state) => Text(state.value ?? ""),
                ),
                GestureDetector(
                  onTap: () => bloc!.addItem(),
                  child: Container(
                    color: Colors.yellow,
                    padding: const EdgeInsets.all(10),
                    child: const Text("click me"),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: BlocBuilder<MainBloc, MainState>(
                    builder: (context, state) => ListView.separated(
                      itemBuilder: (ctx, index) => GestureDetector(
                        onTap: () => bloc!.clickEdit(index),
                        onLongPress: () => bloc!.deleteItem(index),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          color: Colors.yellow,
                          alignment: Alignment.center,
                          child: Text("$index ${state.listItem![index]}"),
                        ),
                      ),
                      separatorBuilder: (ctx, index) => const SizedBox(
                        height: 10,
                      ),
                      itemCount: state.listItem?.length ?? 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
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
