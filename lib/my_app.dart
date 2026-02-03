import 'package:base_flutter_bloc/gen/l10n.dart';
import 'package:base_flutter_bloc/shared/routes/routes.dart';
import 'package:base_flutter_bloc/shared/utils/app_route_tracking.dart';
import 'package:base_flutter_bloc/shared/utils/navigate_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_support/overlay_support.dart';
import 'core/di/injection_container.dart';
import 'features/app/presentation/bloc/app_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      ensureScreenSize: true,
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
            initialRoute: AppRoutes.login.routeName,
            routes: {
              for (AppRoutes e in AppRoutes.values)
                e.routeName: (context) => e.getPage(context)
            },
            navigatorObservers: [AppRouteTracking()],
          ),
        ),
      ),
    );
  }
}
