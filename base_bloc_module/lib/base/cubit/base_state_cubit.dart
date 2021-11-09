import 'package:equatable/equatable.dart';

abstract class BaseStateCubit extends Equatable {
  List<Object?> equal();

  @override
  List<Object?> get props {
    return equal();
  }
}
