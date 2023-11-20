import 'package:cabo/components/main_menu/main_menu_screen.dart';
import 'package:cabo/core/app_navigator/app_navigator.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  setup();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final AppNavigator _appNavigator = AppNavigator();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
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
