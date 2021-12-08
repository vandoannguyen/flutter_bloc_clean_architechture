import 'package:equatable/equatable.dart';

class MainEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ClickMeEvent extends MainEvent {}

class ClickTestTapEvent extends MainEvent {}

class ClickAddEvent extends MainEvent {}

class ClickEditItemList extends MainEvent {
  final int index;

  ClickEditItemList(this.index);
}

class ClickDeleteItemList extends MainEvent {
  final int index;

  ClickDeleteItemList(this.index);
}
