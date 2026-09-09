import 'package:cabo/common/presentation/widgets/cabo_primary_button.dart';
import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/components/statistics/widgets/publish_stage.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/application/auth_service.dart';
import 'package:cabo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QrCodeSection extends StatelessWidget {
  const QrCodeSection({
    required this.gameId,
    required this.ownerId,
    required this.onContinue,
    super.key,
  });

  final String gameId;
  final String? ownerId;

  /// Schließt den Dialog und führt zurück ins Spiel.
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final QrCode qrCode = QrCode.fromData(
      data: gameId,
      errorCorrectLevel: QrErrorCorrectLevel.H,
    );
    final QrImage qrImage = QrImage(qrCode);
    final String? userId = app<AuthService>().currentUser?.uid;
    final bool isOwner = userId == ownerId;

    return SingleChildScrollView(
      key: const ValueKey<String>('qr-code-view'),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.check_circle_rounded,
            color: CaboTheme.m3Secondary,
            size: 72,
          ),
          const SizedBox(height: 16),
          Text(
            isOwner
                ? l10n.publishDialogGamePublished
                : l10n.publishDialogJoinedGame,
            textAlign: TextAlign.center,
            style: CaboTheme.headlineMediumStyle.copyWith(
              color: CaboTheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.publishDialogFriendsCanJoin,
            textAlign: TextAlign.center,
            style: CaboTheme.bodyLargeStyle.copyWith(
              color: CaboTheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          PublishStage(
            backgroundColor: CaboTheme.surfaceContainerLowest,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: PrettyQrView(qrImage: qrImage),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: CaboTheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              gameId,
              style: CaboTheme.labelLargeStyle.copyWith(
                color: CaboTheme.m3Primary,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.publishDialogNextSteps,
            textAlign: TextAlign.center,
            style: CaboTheme.bodyLargeStyle.copyWith(
              color: CaboTheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          CaboPrimaryButton(
            key: const ValueKey<String>('qr-code-continue-button'),
            label: l10n.publishDialogContinueToGame,
            onPressed: onContinue,
            leading: Icon(
              Icons.arrow_forward_rounded,
              size: 24,
              color: CaboTheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.publishDialogCodeStaysAvailable,
            textAlign: TextAlign.center,
            style: CaboTheme.labelSmallStyle.copyWith(
              color: CaboTheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
