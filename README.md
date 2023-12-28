## Package

- [Bloc Pattern: flutter_bloc](https://pub.dev/packages/flutter_bloc)
- [Navigation: auto_route](https://pub.dev/packages/auto_route)
- [DI: get_it](https://pub.dev/packages/get_it)
- [Network: dio](https://pub.dev/packages/dio)
- [Localization: easy_localization](https://pub.dev/packages/easy_localization)
- [Flavors: prod, dev, uat](https://docs.flutter.dev/deployment/flavors)
- [Model generator: Freezed](https://pub.dev/packages/freezed)
-

### Generate file

- flutter packages pub run build_runner build --delete-conflicting-outputs

### Release apk

- flutter build apk --flavor dev -t lib/main_dev.dart

## Base project support:

### Struct

```
│
└───api // network config
│
└───bloc // contains bloc
│    
└───common // contains enum, extension, common functions...
│   
└───di 
│   
└───model 
│   │   
│   └───entity 
│   │   
│   └───local
│   │   
│   └───network
│   │   
│   └───repository
│   
└───routes // config route name and page
│   
└───theme // contains text style, common size, theme data
│   
└───translations // mutiple language
│   
└───utils
│   
└───view
│   
└───gen // gen access file
│   
└───widgets // Contains common widget
│   
└───main.dart
│   
└───firebase_options.dart // config firebase

```

### Usage

BlocBuilderDataState<Cubit, Stata> instead of BlocBuilder

```
    BlocBuilderDataState<MainBloc, MainState>(
      bloc: bloc,
      builder: (context, state) {
        return Text(
          "${state.user?.a}  ${state.user?.b}",
        );
      },
    ),
```

Using BaseViewCubit<Cubit, State> instead of StatelessWidget

```
class MainView extends BaseViewCubit<MainBloc, MainState> {
  MainView({Key? key}) : super(key: key);

  @override
  Widget buildWidget(BuildContext context) {
    return BlocBuilderDataState<MainBloc, MainState>(
      bloc: bloc,
      builder: (context, state) => Text(
        "${state.count}",
      ),
    );
  }

  @override
  MainBloc initBloc() {
    return getIt<MainBloc>();
  }

  @override
  initEventViewModel(BuildContext context, BaseStateCubit state) {
    // define event
  }

  @override
  void initData() {
    // call api data
  }
}

```

Using StatefulWidget

- ViewState must be extends BaseViewCubitState<Cubit, CubitState, State>

```
class MainView2 extends StatefulWidget {
  const MainView2({Key? key}) : super(key: key);

  @override
  State<MainView2> createState() => _MainView2State();
}

class _MainView2State
    extends BaseViewCubitState<Main2Bloc, Main2State, MainView2> {
  @override
  Widget buildWidget(BuildContext context) {
    return Container(
      child: BlocBuilderDataState<Main2Bloc, Main2State>(
        builder: (BuildContext context, Main2State state) {
          return Container();
        },
      ),
    );
  }

  @override
  Main2Bloc initBloc() {
    return getIt<Main2Bloc>();
  }

  @override
  void initData() {}

  @override
  void initEventViewModel(BuildContext context, BaseCubitEvent state) {}
}

```

Cubit

```
@injectable
class MainCubit extends BaseCubit<MainState> {
  ContentRepository contentUseCase;
  int couter = 0;

  @factoryMethod
  MainCubit(this.contentUseCase) : super(MainState());

  void testTap() {
    ContentModel? user = dataState.user?.copyWith();
    emit(dataState.copyWith(user: user));//Update screen data
    emit(MainViewEvent.showDialog());//Push event to screen
  }
}
```
State Data
```
part 'main_view_sate.freezed.dart';

@Freezed(equal: true)
class MainState extends BaseDataStateCubit with _$MainState {
  factory MainState(
      {@Default(0) int? count,
      @Default("value") String value,
      ContentModel? user}) = _MainState;
}
```
State Event
```
part 'main_view_event.freezed.dart';

@freezed
class MainViewEvent extends BaseCubitEvent with _$MainViewEvent {
  const factory MainViewEvent.getData() = GetData;

  const factory MainViewEvent.showMessage() = ShowMessage;
}
```
### Show loading dialog

Show Loading (invoke inside cubit):

```
showLoading()
```

Hide loading (invoke inside cubit):

```
hideLoading()
```

Custom loading dialog UI:

```
import 'package:base_bloc_module/common/base_bloc_config.dart';

  BaseBlocConfig.instance.configLoadingWidget(() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  });
```

### Show common message:

Show Message (invoke inside cubit)

```
  showMessage(String message, {MessageType type = MessageType.success})
```

Custom message UI:

```
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
```

### Navigate to other screen (inside cubit):

```
  changeScreen(String routeName, dynamic data)
```

## Navigate

NavigatorUtils

```
         MaterialApp(
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
```

Using as Navigator.of(context)

```
  Navigator.of(context).pushNamed() => NavigatorUtils.instance.pushNamed()
  Navigator.of(context).pushNamedAndRemoveUntil() => NavigatorUtils.instance.pushNamedAndRemoveUntil()
  Navigator.of(context).pushReplacementNamed() => NavigatorUtils.instance.pushReplacementNamed()
  Navigator.of(context).push() => NavigatorUtils.instance.push()
```

Config route:

- Define route name:

```
class AppRoutes {
  static const INIT = "/";

  static const MAIN2 = "/main2";
}
```

- Define Page by route

```
class AppPage {
  static List pages = [
    RouteModel(
      AppRoutes.INIT,
      MainView(),
    ),
    RouteModel(
      AppRoutes.MAIN2,
      const MainView2(),
    ),
  ];
}

class RouteModel {
  String name;
  Widget page;

  RouteModel(this.name, this.page);
}

```

## Multiple language

```
 import 'package:easy_localization/easy_localization.dart';
 "language".tr()
```

## Flavor

Using

- [Flutter dotenv](https://pub.dev/packages/flutter_dotenv)

Config env in

```
│
└───evn
```

In Android
----------- 
Add google_services.json to

```
│
└───android
│   └─── app
│            └─── dev 
│            └─── uat
│            └─── prod
```

Change applicationId & App name in android/app/build.gradle

```
    flavorDimensions "app"

    productFlavors {
        dev {
            dimension "app"
            resValue "string","app_name","Base Bloc Flutter 3 Dev"
            applicationId "com.example.base_bloc_3.dev"
        }
        uat {
            dimension "app"
            resValue "string","app_name","Base Bloc Flutter 3 Stagin"
            applicationId "com.example.base_bloc_3.staging"
        }
        prod {
            dimension "app"
            resValue "string", "app_name", "Base Bloc Flutter 3"
        }

    }
```

```
    applicationId "com.example.base_bloc_3"
```

In IOS
------
Add google google_services.plist to

```
│
└───Runner
│   └─── FirebaseConfig
│            └─── dev 
│            └─── uat
│            └─── prod
```

Change Product Bundle Identifier in Runner/Targets/Runner/Build Setting/Product Bundle Identifier
Change App Display Name in Runner/Targets/Runner/Build Setting/User-Defined/APP_NAME
##Template Live code Android Studio
- copy Flutter.xml to 
```
/Users/{User Name}/Library/Application Support/Google/AndroidStudio{version}/templates
```