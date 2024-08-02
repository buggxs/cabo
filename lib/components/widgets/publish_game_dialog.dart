import 'package:cabo/misc/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class ShowPublishGameScreen extends StatefulWidget {
  const ShowPublishGameScreen({
    super.key,
    required this.publishGame,
  });

  final Future<String?> Function() publishGame;

  @override
  State<ShowPublishGameScreen> createState() => _ShowPublishGameScreenState();
}

class _ShowPublishGameScreenState extends State<ShowPublishGameScreen> {
  String? publicGameId;

  void onPublish() async {
    String? newPublicGameId = await widget.publishGame();
    setState(() {
      publicGameId = newPublicGameId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: publicGameId == null
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)!.publishDialogTitle,
                  style: title,
                  textAlign: TextAlign.center,
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onPublish,
                        style: dialogButtonStyle,
                        child: Text(
                          AppLocalizations.of(context)!
                              .publishDialogButtonPublishText,
                          style: const TextStyle(
                            fontFamily: 'Aclonica',
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        style: dialogButtonStyle,
                        child: Text(
                          AppLocalizations.of(context)!
                              .publishDialogButtonCloseText,
                          style: const TextStyle(
                            fontFamily: 'Aclonica',
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)!.publishDialogTitle,
                  style: title,
                  textAlign: TextAlign.center,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      height: 250,
                      width: 250,
                      child: PrettyQrView.data(
                        data:
                            'http://cabo-web.eu-central-1.elasticbeanstalk.com/online-game/$publicGameId',
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
