import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QrCodeSection extends StatelessWidget {
  const QrCodeSection({required this.gameId, required this.ownerId, super.key});

  final String gameId;
  final String? ownerId;

  @override
  Widget build(BuildContext context) {
    final QrCode qrCode = QrCode.fromData(
      data: gameId,
      errorCorrectLevel: QrErrorCorrectLevel.H,
    );
    final QrImage qrImage = QrImage(qrCode);
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    return Column(
      key: const ValueKey<String>('qr-code-view'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Icon(
          Icons.check_circle_outline_rounded,
          color: Colors.greenAccent,
          size: 100,
        ),
        const SizedBox(height: 20),
        Text(
          userId != ownerId
              ? AppLocalizations.of(context)!.publishDialogJoinedGame
              : AppLocalizations.of(context)!.publishDialogGamePublished,
          textAlign: TextAlign.center,
          style: CaboTheme.primaryTextStyle.copyWith(fontSize: 26),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            AppLocalizations.of(context)!.publishDialogFriendsCanJoin,
            textAlign: TextAlign.center,
            style: CaboTheme.primaryTextStyle.copyWith(fontSize: 22),
          ),
        ),
        const SizedBox(height: 30),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          width: 200,
          height: 200,
          child: PrettyQrView(qrImage: qrImage),
        ),
        const SizedBox(height: 16),
        Text(
          gameId,
          style: CaboTheme.secondaryTextStyle.copyWith(
            fontSize: 20,
            color: CaboTheme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
