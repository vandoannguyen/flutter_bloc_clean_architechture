import 'package:base_bloc_module/base/cubit/base_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/base_state_cubit.dart';

class BlocBuilderDataState<B extends StateStreamable<BaseStateCubit>,
    S extends BaseStateCubit> extends BlocBuilder<B, BaseStateCubit> {
  BlocBuilderDataState(
      {super.key,
      super.bloc,
      required BlocWidgetBuilder<S> builder,
      Function(S, S)? buildWhen})
      : super(
          buildWhen: (previous, current) =>
              current is S && _checkBuildWhen(previous, current, buildWhen),
          builder: (ctx, state) => (state is S)
              ? builder(ctx, state)
              : builder(
                  ctx,
                  (ctx.read<B>() as BaseCubit<S>).dataState,
                ),
        );

  static bool _checkBuildWhen<S extends BaseStateCubit>(
      BaseStateCubit previous, S current, Function(S, S)? buildWhen) {
    return buildWhen != null && previous is S
        ? buildWhen(previous, current)
        : true;
  }
}
