import 'package:base_bloc_module/base/cubit/base_cubit.dart';
import 'package:base_bloc_module/views/widgets/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
abstract class BaseViewCubit<CUBIT extends BaseCubit,
    STATE extends StatefulWidget> extends State<STATE> {
  CUBIT? bloc;
  late BuildContext contextScreen;

  Widget buildWidget(BuildContext context);

  @override
  void initState() {
    super.initState();
    bloc ??= initBloc();
    initEventViewModel();
  }

  @override
  Widget build(BuildContext context) {
    contextScreen = context;
    return BlocProvider<CUBIT>(
      create: (ctx) => bloc!,
      child: buildWidget(context),
    );
  }

  @override
  void dispose() {
    bloc?.close();
    super.dispose();
  }

  /// getBloc
  CUBIT initBloc();

  /// function allow handle listen which broadcast from bloc
  void initEventViewModel() {
    bloc?.dialogLoading.stream.listen((event) {
      if (event == true) {
        showDialog(
          context: contextScreen,
          builder: (ctx) => const LoadingWidget(),
        );
      } else {
        Navigator.of(contextScreen).pop();
      }
    });
    bloc?.showMessage.stream.listen((event) {});
    bloc?.toName.stream.listen((event) {
      Navigator.pushNamed(contextScreen, event);
    });
    bloc?.back.stream.listen((event) {
      Navigator.pop(contextScreen, event);
    });
  }
}
