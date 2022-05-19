import 'dart:io';

import 'package:baese_flutter_bloc/common/utils/navigate_utils.dart';
import 'package:baese_flutter_bloc/routes/pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import 'di/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  if (Platform.isIOS) {
    await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBw3oZA1GOwGMUD_kTeHpIng4uvLX4KznM",
        appId: "1:202259391088:android:6dff38437d119458c7cab5",
        projectId: "baseflutterapp",
        messagingSenderId: '202259391088',
      ),
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        title: 'Flutter Demo',
        navigatorKey: NavigateUtils.instance.navigatorKey,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: "/",
        routes: {
          for (RouteModel e in CommonPage.pages) e.name: (context) => e.page
        },
      ),
    );
  }
}
