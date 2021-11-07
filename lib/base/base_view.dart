import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'base_bloc.dart';

// ignore: must_be_immutable
abstract class BaseView<BLOC extends BaseBloc, STATE extends StatefulWidget>
    extends State<STATE> {
  BLOC? bloc;
  late BuildContext context;

  void initEventViewModel();

  Widget buildWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    this.context = context;
    bloc ??= _getBloc(context);
    initEventViewModel();
    return buildWidget(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  BLOC _getBloc(BuildContext context) {
    return BlocProvider.of<BLOC>(context);
  }
}
