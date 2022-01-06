import 'package:firebase_core/firebase_core.dart';
import 'package:firestore_helper/firestore_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:secretum/pages/authentication/authentication_page.dart';
import 'package:secretum/pages/intro/intro_page.dart';
import 'package:secretum/services/authentication_service.dart';
import 'package:secretum/services/encryption_service.dart';
import 'package:secretum/services/firestore/fire_secrets_service.dart';
import 'package:secretum/services/firestore/fire_users_service.dart';
import 'package:secretum/services/logging_service.dart';
import 'package:secretum/services/storage_service.dart';
import 'package:secretum/stores/secrets_store.dart';
import 'package:secretum/stores/users_store.dart';
import 'package:provider/provider.dart';

// Globals
AppLifecycleState? appLifecycleState;
late LoggingService loggingService;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// [isAuthenticationPageShown] is introduced to tackle different Biometrics behaviour within Android and iOS devices.
///
/// Android shows Fragment, and activity is not paused, while iOS pauses the app and shows Biometrics screen
/// triggering AppLifecycleState to change. After iOS auth is success, [AppLifecycleState] becomes [AppLifecycleState.resumed] thus
/// we are in the loop.
/// Current way simply ensures that if [AuthenticationPage] is shown, bringing app from background won't
/// trigger Biometrics.
bool isAuthenticationPageShown = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);

    final GetIt serviceLocator = GetIt.instance;

    /// Services
    /// Global
    serviceLocator.registerSingleton(LoggingService());
    loggingService = GetIt.instance<LoggingService>();

    /// Other
    // Encryption is reusable within other services thus need to initialise it first
    serviceLocator.registerSingleton(EncryptionService());
    serviceLocator.registerSingleton(AuthenticationService());
    serviceLocator.registerSingleton(
      FirestoreHelper(includeAdditionalFields: false, isLoggingEnabled: !kReleaseMode),
    );
    serviceLocator.registerSingleton(FireSecretsService());
    serviceLocator.registerSingleton(FireUsersService());
    serviceLocator.registerSingleton(StorageService());

    /// Stores
    serviceLocator.registerSingleton(UsersStore());
    serviceLocator.registerSingleton(SecretsStore());
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    loggingService.log('_MyAppState.didChangeAppLifecycleState: $state');

    void _initBiometrics() {
      final BuildContext? context = navigatorKey.currentContext;

      // Make sure we don't show second Auth page on top when user is already in Auth page.
      if (!isAuthenticationPageShown && context != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AuthenticationPage()));
      }
    }

    switch (state) {
      case AppLifecycleState.resumed:
        _initBiometrics();
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
        ChangeNotifierProvider(create: (_) => GetIt.instance<UsersStore>()),
        ChangeNotifierProvider(create: (_) => GetIt.instance<SecretsStore>()),
      ],
      child: MaterialApp(
        title: 'Secretum',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          colorScheme: ColorScheme.dark(),
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
          // Cannot use GoogleFonts because it will completely override colors
          // Ignoring `brightness` setting. Therefore use manual font selection
          fontFamily: 'Montserrat',
        ),
        navigatorKey: navigatorKey,
        home: IntroPage(),
      ),
    );
  }
}
