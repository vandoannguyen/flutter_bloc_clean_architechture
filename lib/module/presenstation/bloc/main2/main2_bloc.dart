import 'package:baese_flutter_bloc/module/domain/usecase/content_usecase.dart';
import 'package:base_bloc_module/base/cubit/base_cubit.dart';
import 'package:injectable/injectable.dart';

import 'main2_state.dart';

@injectable
class Main2Bloc extends BaseCubit<Main2State> {
  ContentUseCase contentUseCase;

  @factoryMethod
  Main2Bloc(this.contentUseCase) : super(Main2State());

  @override
  void closeStream() {}
}
