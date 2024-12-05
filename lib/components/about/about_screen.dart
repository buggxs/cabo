import 'package:cabo/components/about/cubit/about_cubit.dart';
import 'package:cabo/components/main_menu/widgets/dark_screen_overlay.dart';
import 'package:cabo/components/main_menu/widgets/menu_button.dart';
import 'package:cabo/misc/widgets/cabo_text_field.dart';
import 'package:cabo/misc/widgets/cabo_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const route = 'about_screen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AboutCubit(),
      child: const AboutScreenContent(),
    );
  }
}

class AboutScreenContent extends StatelessWidget {
  const AboutScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    AboutCubit cubit = context.watch<AboutCubit>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: CaboTheme.primaryColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppLocalizations.of(context)!.aboutScreenTitle,
          style: CaboTheme.primaryTextStyle.copyWith(
            fontSize: 38,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/cabo-main-menu-background.png'),
            fit: BoxFit.cover,
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: DarkScreenOverlay(
          darken: 0.70,
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48.0,
                    vertical: 6,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.aboutScreenText,
                    style: CaboTheme.secondaryTextStyle.copyWith(
                      color: CaboTheme.primaryColor,
                      fontFamily: 'Archivo Black',
                      fontWeight: FontWeight.w800,
                      shadows: [
                        Shadow(
                          // topRight
                          offset: const Offset(1.5, 1.5),
                          color: Colors.black.withAlpha(200),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48.0,
                    vertical: 6,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!
                        .aboutScreenTextAreaDescription,
                    style: CaboTheme.secondaryTextStyle.copyWith(
                      color: CaboTheme.primaryColor,
                      fontSize: 16,
                      shadows: [
                        Shadow(
                          // topRight
                          offset: const Offset(1.5, 1.5),
                          color: Colors.black.withAlpha(200),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48.0,
                    vertical: 6,
                  ),
                  child: CaboTextField(
                    labelText:
                        AppLocalizations.of(context)!.aboutScreenTextAreaLabel,
                    maxLines: 5,
                    minLines: 5,
                    keyboardType: TextInputType.multiline,
                    onChanged: (String message) => cubit.updateMessage(message),
                  ),
                ),
                MenuButton(
                  text: AppLocalizations.of(context)!.aboutScreenSendButton,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48.0,
                    vertical: 6,
                  ),
                  textStyle: CaboTheme.primaryTextStyle.copyWith(
                    fontSize: 22,
                  ),
                  innerPadding: const EdgeInsets.all(4),
                  onTap: () {
                    cubit.sendEmail();
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            AppLocalizations.of(context)!.aboutScreenSuccess),
                      ),
                    );
                  },
                ),
                const Spacer(),
                Text(
                  '© Andre Salzmann 2025',
                  style: CaboTheme.primaryTextStyle.copyWith(
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
