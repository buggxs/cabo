import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/common/presentation/widgets/dark_screen_overlay.dart';
import 'package:cabo/components/application/cubit/application_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CaboScaffold extends StatelessWidget {
  const CaboScaffold({
    required this.child,
    this.withDarkOverlay = false,
    super.key,
  });

  final Widget child;
  final bool withDarkOverlay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: kDebugMode
            ? [
                BlocBuilder<ApplicationCubit, ApplicationState>(
                  builder: (context, state) {
                    if (state is ApplicationAuthenticated) {
                      return IconButton(
                        onPressed: () {
                          context.read<ApplicationCubit>().signOut();
                        },
                        icon: const Icon(
                          Icons.logout,
                          color: CaboTheme.primaryColor,
                        ),
                      );
                    }
                    return IconButton(
                      onPressed: () {
                        context.read<ApplicationCubit>().signInWithGoogle();
                      },
                      icon: const Icon(
                        Icons.login,
                        color: CaboTheme.primaryColor,
                      ),
                    );
                  },
                ),
              ]
            : null,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/cabo-main-menu-background.png'),
            fit: BoxFit.cover,
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: withDarkOverlay ? DarkScreenOverlay(child: child) : child,
      ),
    );
  }
}
