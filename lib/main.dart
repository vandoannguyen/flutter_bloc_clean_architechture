import 'package:base_bloc_module/common/base_bloc_config.dart';
import 'package:base_bloc_module/models/message_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'di/injection_container.dart';
import 'my_app.dart';

String envConfig(String flavor) {
  switch (flavor) {
    case 'dev':
      return 'env/.env_dev';
    case 'uat':
      return 'env/.env_uat';
    case 'prod':
      return 'env/.env_prod';
    default:
      return 'env/.env_dev';
  }
}

void main() async {
  const flavor = String.fromEnvironment('flavor', defaultValue: 'dev');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  BaseBlocConfig.instance.configLoadingWidget(() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  });
  BaseBlocConfig.instance.configMessageWidget((messageModel) {
    return Text(
      messageModel.mess,
      style: TextStyle(
        color: messageModel.messageType == MessageType.waring
            ? Colors.orange
            : messageModel.messageType == MessageType.error
                ? Colors.red
                : Colors.green,
      ),
    );
  });
  await dotenv.load(fileName: envConfig(flavor));
  await configureDependencies();
  runApp(const MyApp());
}
