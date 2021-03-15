import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:secretum/pages/intro/intro_page.dart';
import 'package:secretum/services/encryption_service.dart';
import 'package:secretum/services/firestore/fire_secrets_service.dart';
import 'package:secretum/services/firestore/fire_users_service.dart';
import 'package:secretum/services/firestore/generic/firestore_generic_service.dart';
import 'package:secretum/services/logging_service.dart';
import 'package:secretum/services/storage_service.dart';
import 'package:secretum/stores/secrets_store.dart';
import 'package:secretum/stores/users_store.dart';
import 'package:secretum/utils/utils.dart';
import 'package:provider/provider.dart';

//Globals
AppLifecycleState? appLifecycleState;
late LoggingService loggingService;
late EncryptionService encryptionService;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

///[isBiometricAuthShowing] is introduced to tackle different Biometrics behaviour within Android and iOS devices.
///Android shows Fragment, and activity is not paused, while iOS pauses the app and shows Biometrics screen
///triggering AppLifecycleState to change. After iOS auth is success, AppLifecycleState becomes resume thus
///we are in the loop.
///Current way simply ensures that if Biometrics screen is shown, other won't be shown.
///It still seems to fail sometimes (on iOS), but fairly rarely.
bool isBiometricAuthShowing = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);

    GetIt serviceLocator = GetIt.instance;

    //Services
    //Global
    serviceLocator.registerSingleton(LoggingService());
    loggingService = GetIt.instance<LoggingService>();

    serviceLocator.registerSingleton(EncryptionService());
    encryptionService = GetIt.instance<EncryptionService>();

    //Other
    serviceLocator.registerSingleton(StorageService());
    serviceLocator.registerSingleton(FireGenericService());
    serviceLocator.registerSingleton(FireUsersService());
    serviceLocator.registerSingleton(FireSecretsService());

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    loggingService.log("_MyAppState.didChangeAppLifecycleState: $state");

    switch (state) {
      case AppLifecycleState.resumed:
        if (!isBiometricAuthShowing) {
          bool isSuccess = await Utils.authViaBiometric();
          if (!isSuccess) {
            Utils.closeApp();
          }
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        break;
    }

    appLifecycleState = state;
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UsersStore()),
        ChangeNotifierProvider(create: (_) => SecretsStore()),
      ],
      child: MaterialApp(
        title: 'Local Demo',
        theme: ThemeData(
          accentColor: Colors.white,
          primarySwatch: Colors.cyan,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          brightness: Brightness.dark,
          buttonTheme: Theme.of(context).buttonTheme.copyWith(),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              onPrimary: Colors.white.withOpacity(0.8),
              padding: EdgeInsets.all(12),
            ),
          ),
        ),
        navigatorKey: navigatorKey,
        home: IntroPage(),
      ),
    );
  }
}
