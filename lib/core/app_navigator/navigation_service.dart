import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<T?> showAppDialog<T>(
      {required Dialog Function(BuildContext context) dialog,}) {
    return showDialog(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) => dialog.call(context),
    );
  }
}
