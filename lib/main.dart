import 'package:cabo/components/application/cubit/application_cubit.dart';
import 'package:cabo/components/main_menu/main_menu_screen.dart';
import 'package:cabo/core/app_navigator/app_navigator.dart';
import 'package:cabo/core/app_navigator/navigation_service.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/firebase_options.dart';
import 'package:cabo/misc/widgets/cabo_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logging/logging.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kDebugMode) {
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  }

  // initialize get_it
  setup();

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    if (kDebugMode) {
      print(
        '${record.level.name} - ${record.loggerName} : ${record.time}: ${record.message}',
      );
    }
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final AppNavigator _appNavigator = AppNavigator();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ApplicationCubit>(
      create: (_) => ApplicationCubit(),
      child: MaterialApp(
        title: 'Cabo Board',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: CaboTheme.primaryColor.toMaterialColor,
        ),
        navigatorKey: app<NavigationService>().navigatorKey,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('de'),
          Locale('en'),
        ],
        onGenerateRoute: _appNavigator.generateRoute,
        home: const MainMenuScreen(),
      ),
    );
  }
}
