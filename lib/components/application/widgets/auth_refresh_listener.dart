import 'dart:async';

import 'package:cabo/components/application/cubit/application_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Re-checks the verification status whenever the app comes back to the
/// foreground while an account is still unconfirmed.
///
/// This is what makes the flow work when the deep link does not open the app:
/// both platforms suppress the app handoff on a server redirect, so returning
/// to the app manually has to be enough.
class AuthRefreshListener extends StatefulWidget {
  const AuthRefreshListener({required this.child, super.key});

  final Widget child;

  @override
  State<AuthRefreshListener> createState() => _AuthRefreshListenerState();
}

class _AuthRefreshListenerState extends State<AuthRefreshListener> {
  late final AppLifecycleListener _lifecycleListener;

  @override
  void initState() {
    super.initState();
    _lifecycleListener = AppLifecycleListener(onResume: _refreshIfPending);
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    super.dispose();
  }

  void _refreshIfPending() {
    if (!mounted) return;
    final ApplicationCubit cubit = context.read<ApplicationCubit>();
    if (cubit.state.isAwaitingEmailVerification) {
      unawaited(cubit.refreshVerificationStatus());
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
