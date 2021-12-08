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
    return BlocListener<MainBloc, MainState>(
      listener: (ctx, state) {},
      child: Scaffold(
        backgroundColor: Colors.red,
        body: SafeArea(
          child: GestureDetector(
            onTap: () => bloc?.add(ClickTestTapEvent()),
            child: Container(
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BlocBuilder<MainBloc, MainState>(
                        builder: (context, state) => Text("${state.count}")),
                    BlocBuilder<MainBloc, MainState>(
                        builder: (context, state) =>
                            Text("${state.test?.name1}\n${state.test?.name2}")),
                    GestureDetector(
                      onTap: () {
                        bloc?.add(ClickMeEvent());
                      },
                      child: Container(
                        color: Colors.yellowAccent,
                        padding: const EdgeInsets.all(10),
                        child: const Text("Click Me"),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        bloc?.add(ClickAddEvent());
                      },
                      child: Container(
                        color: Colors.yellowAccent,
                        padding: const EdgeInsets.all(10),
                        child: const Text("Click Add"),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: BlocBuilder<MainBloc, MainState>(
                        builder: (context, state) => ListView.separated(
                          itemBuilder: (ctx, index) => GestureDetector(
                            onTap: () => bloc?.add(ClickEditItemList(index)),
                            onLongPress: () =>
                                bloc?.add(ClickDeleteItemList(index)),
                            child: Container(
                              height: 30,
                              color: Colors.yellow,
                              alignment: Alignment.center,
                              child: Text("$index ${state.listItem![index]}"),
                            ),
                          ),
                          separatorBuilder: (ctx, index) => const SizedBox(
                            height: 5,
                          ),
                          itemCount: state.listItem?.length ?? 0,
                        ),
                      ),
                    )
                  ],
                )),
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
