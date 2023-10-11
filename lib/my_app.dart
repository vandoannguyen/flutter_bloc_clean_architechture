import 'package:baese_flutter_bloc/routes/pages.dart';
import 'package:baese_flutter_bloc/utils/app_route_tracking.dart';
import 'package:baese_flutter_bloc/utils/navigate_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';

import 'bloc/app/app_bloc.dart';
import 'di/injection_container.dart';
import 'routes/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AppBloc>(
            create: (BuildContext context) => getIt<AppBloc>(),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          navigatorKey: NavigatorUtils.instance.navigatorKey,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: AppRoutes.INIT,
          routes: {
            for (RouteModel e in AppPage.pages) e.name: (context) => e.page
          },
          navigatorObservers: [AppRouteTracking()],
        ),
      ),
    );
  }
}
