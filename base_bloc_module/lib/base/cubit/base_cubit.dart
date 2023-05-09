import 'package:bloc/bloc.dart';

abstract class BaseCubit<STATE> extends Cubit<STATE> {
  BaseCubit(STATE initialState) : super(initialState);
}
