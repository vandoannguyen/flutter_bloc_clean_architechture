import 'package:baese_flutter_bloc/routes/pages.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import 'common/utils/navigate_utils.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        title: 'Flutter Demo',
        navigatorObservers: [observer],
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
