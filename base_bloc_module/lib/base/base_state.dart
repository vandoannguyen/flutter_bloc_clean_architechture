import 'package:equatable/equatable.dart';

abstract class BaseState extends Equatable {
  List<Object?> equal();

  @override
  List<Object?> get props {
    return equal();
  }
}
