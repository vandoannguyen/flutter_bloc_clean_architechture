import 'package:baese_flutter_bloc/routes/pages.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import 'di/injection_container.dart';

void main() async {
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        title: 'Flutter Demo',
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
