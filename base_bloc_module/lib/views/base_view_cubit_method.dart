import 'package:flutter/cupertino.dart';

import '../base/cubit/base_cubit.dart';
import '../base/cubit/base_cubit_event.dart';

abstract class BaseViewCubitMethod<CUBIT extends BaseCubit> {
  CUBIT? bloc;

  void _showMessage(BuildContext context, OnMessageEvent state);

  void _showLoading(BuildContext context, OnLoadingEvent state);

  void onChangeScreen(BuildContext context, OnChangeScreenEvent state);

  void initEventViewModel(BuildContext context, BaseCubitEvent state);

  Widget buildWidget(BuildContext context);

  void initData();

  /// getBloc
  CUBIT initBloc();
}
