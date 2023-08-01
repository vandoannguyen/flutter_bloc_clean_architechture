import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/base_state_cubit.dart';

class BlocBuilderDataState<B extends StateStreamable<BaseStateCubit>,
    S extends BaseStateCubit> extends BlocBuilder<B, BaseStateCubit> {
  BlocBuilderDataState(
      {Key? key,
      B? bloc,
      required BlocWidgetBuilder<S> builder,
      Function(S, S)? buildWhen})
      : super(
          key: key,
          bloc: bloc,
          buildWhen: (previous, current) =>
              current is S && _checkBuildWhen(previous, current, buildWhen),
          builder: (ctx, state) =>
              (state is S) ? builder(ctx, state) : Container(),
        );

  static bool _checkBuildWhen<S extends BaseStateCubit>(
      BaseStateCubit previous, S current, Function(S, S)? buildWhen) {
    return buildWhen != null && previous is S
        ? buildWhen(previous, current)
        : true;
  }
}
