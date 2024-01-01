import 'package:base_flutter_bloc/gen/l10n.dart';
import 'package:base_flutter_bloc/utils/app_route_tracking.dart';
import 'package:base_flutter_bloc/utils/navigate_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_support/overlay_support.dart';
import 'bloc/app/app_bloc.dart';
import 'di/injection_container.dart';
import 'routes/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (ctx, _) => OverlaySupport.global(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AppBloc>(
              create: (BuildContext context) => getIt<AppBloc>(),
            ),
          ],
          child: MaterialApp(
            title: 'Flutter Demo',
            localizationsDelegates: const [
              Languages.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
            ],
            navigatorKey: NavigatorUtils.instance.navigatorKey,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            initialRoute: AppRoutes.INIT.routeName,
            routes: {
              for (AppRoutes e in AppRoutes.values)
                e.name: (context) => e.getPage(context)
            },
            navigatorObservers: [AppRouteTracking()],
          ),
        ),
      ),
    );
  }
}
