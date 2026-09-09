import 'package:cabo/common/presentation/widgets/cabo_primary_button.dart';
import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/common/presentation/widgets/context_extensions.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/donation/donation_service.dart';
import 'package:flutter/material.dart';

/// Card on the about screen offering PayPal and Buy Me a Coffee donations.
class DonationCard extends StatelessWidget {
  const DonationCard({super.key});

  Future<void> _openLink(
    BuildContext context,
    Future<bool> Function() openLink,
  ) async {
    final bool isOpened = await openLink();
    if (isOpened || !context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.aboutScreenDonationError),
        backgroundColor: CaboTheme.m3Error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DonationService donationService = app<DonationService>();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: CaboTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CaboTheme.outlineVariant),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x143D3A35),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Icon(Icons.favorite, color: CaboTheme.m3Primary, size: 40),
          const SizedBox(height: 12),
          Text(
            context.l10n.aboutScreenDonationTitle,
            textAlign: TextAlign.center,
            style: CaboTheme.headlineMediumStyle.copyWith(
              color: CaboTheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.aboutScreenDonationDescription,
            textAlign: TextAlign.center,
            style: CaboTheme.bodyMediumStyle.copyWith(
              color: CaboTheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          CaboPrimaryButton(
            label: context.l10n.aboutScreenDonationPaypalButton,
            onPressed: () => _openLink(context, donationService.openPaypal),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () =>
                _openLink(context, donationService.openBuyMeACoffee),
            style: OutlinedButton.styleFrom(
              foregroundColor: CaboTheme.m3Primary,
              side: BorderSide(
                color: CaboTheme.primaryContainer.withValues(alpha: 0.3),
                width: 2,
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
              ),
            ),
            icon: Icon(Icons.local_cafe_outlined, color: CaboTheme.m3Primary),
            label: Text(
              context.l10n.aboutScreenDonationCoffeeButton,
              style: CaboTheme.labelLargeStyle.copyWith(
                color: CaboTheme.m3Primary,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
