import 'package:base_bloc_module/base/cubit/base_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
abstract class BaseViewCubit<CUBIT extends BaseCubit> extends StatelessWidget {
  CUBIT? bloc;
  late BuildContext contextScreen;

  Widget buildWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    contextScreen = context;
    bloc ??= initBloc();
    return BlocProvider<CUBIT>(
      create: (context) => bloc!,
      child: Stack(
        children: [
          buildWidget(context),
          BlocListener<CUBIT, Object?>(
            listener: (ctx, state) {
              initEventViewModel(state);
            },
          )
        ],
      ),
    );
  }

  /// getBloc
  CUBIT initBloc();

  /// function allow handle listen which broadcast from bloc
  void initEventViewModel(Object? state);
}
