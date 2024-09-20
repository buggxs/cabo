import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GameHeader extends StatelessWidget {
  const GameHeader({super.key});

  static const TextStyle style = TextStyle(
    color: Color.fromRGBO(81, 120, 30, 1.0),
    fontFamily: 'Aclonica',
    fontSize: 74,
    fontWeight: FontWeight.bold,
    letterSpacing: 10.0,
    shadows: [
      Shadow(
        color: Color.fromRGBO(32, 45, 18, 1.0),
        blurRadius: 2.0,
        offset: Offset(
          2.0,
          2.0,
        ),
      ),
      Shadow(
        color: Color.fromRGBO(32, 45, 18, 1.0),
        blurRadius: 2.0,
        offset: Offset(
          2.0,
          -2.0,
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              SizedBox(
                height: 250,
                width: 300,
                child: Text(
                  AppLocalizations.of(context)!.gameName,
                  style: style,
                ),
              ),
              Positioned(
                top: 60,
                right: 60,
                child: Text(
                  AppLocalizations.of(context)!.gameSubTitle,
                  style: style.copyWith(
                    fontSize: 48,
                    letterSpacing: 1,
                    color: const Color.fromRGBO(187, 208, 0, 1.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
