import 'package:cabo/components/main_menu/main_menu_screen.dart';
import 'package:cabo/core/app_navigator/app_navigator.dart';
import 'package:cabo/core/app_navigator/navigation_service.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/misc/widgets/cabo_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logging/logging.dart';

void main() {
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
    return MaterialApp(
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
    );
  }
}
