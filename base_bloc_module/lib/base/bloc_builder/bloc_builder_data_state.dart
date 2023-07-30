class BlocBuilderDataState<B extends StateStreamable<BaseStateCubit>,
S extends BaseStateCubit> extends BlocBuilder<B, BaseStateCubit> {
  BlocBuilderDataState(
      {Key? key, B? bloc, required BlocWidgetBuilder<S> builder})
      : super(
      key: key,
      bloc: bloc,
      builder: (ctx, state) =>
      (state is S)
          ? builder(ctx, state as S)
          : Container());

  @override
  BlocBuilderCondition? get buildWhen =>
          (previous, current) {
        return current is BaseDataStateCubit;
      };
}
