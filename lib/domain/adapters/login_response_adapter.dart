import 'package:base_flutter_bloc/domain/adapters/base_adapter.dart';
import 'package:base_flutter_bloc/domain/entities/login_response/login_response_entity.dart';
import 'package:base_flutter_bloc/data/models/login_response/login_response_model.dart';

class LoginResponseAdapter
    extends BaseAdapter<LoginResponseEntity, LoginResponseModel> {
  @override
  entityToModel(data) {
    return LoginResponseModel();
  }

  @override
  modelToEntity(data) {
    return LoginResponseEntity();
  }
}

