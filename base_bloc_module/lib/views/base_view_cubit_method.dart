import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import '../base/cubit/base_cubit.dart';
import '../base/cubit/base_cubit_event.dart';
import '../common/base_bloc_config.dart';
import '../models/message_model.dart';
import 'widgets/loading_widget.dart';

abstract class BaseViewCubitMethod<CUBIT extends BaseCubit> {
  CUBIT? bloc;

  void showMessage(BuildContext context, OnMessageEvent state) {
    if (BaseBlocConfig.instance.messageWidget != null) {
      showSimpleNotification(
        BaseBlocConfig.instance.messageWidget!(state.message),
        background: Colors.transparent,
      );
    } else {
      showSimpleNotification(
        Text(state.message.mess),
        background: state.message.messageType == MessageType.error
            ? Colors.red
            : Colors.green,
      );
    }
  }

  void showLoading(BuildContext context, OnLoadingEvent state) {
    if (state.isLoading == true) {
      showDialog(
        context: context,
        builder: (ctx) => BaseBlocConfig.instance.loadingWidget != null
            ? BaseBlocConfig.instance.loadingWidget!()
            : const LoadingWidget(backgroundColor: Colors.black12),
      );
    } else {
      Navigator.pop(context);
    }
  }

  void onChangeScreen(BuildContext context, OnChangeScreenEvent state) {
    Navigator.of(context).pushNamed(state.route, arguments: state.data);
  }

  void initEventViewModel(BuildContext context, BaseCubitEvent state);

  Widget buildWidget(BuildContext context);

  void initData();

  /// getBloc
  CUBIT initBloc();
}
