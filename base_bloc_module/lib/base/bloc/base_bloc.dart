import 'dart:async';
import 'package:bloc/bloc.dart';

abstract class BaseBloc<EVENT, STATE> extends Bloc<EVENT, STATE> {
  BaseBloc(STATE initialState) : super(initialState);
}
