import 'package:cabo/common/presentation/widgets/cabo_primary_button.dart';
import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/components/statistics/widgets/publish_stage.dart';
import 'package:cabo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class PublishGameSection extends StatelessWidget {
  const PublishGameSection({
    required this.onPublish,
    this.isPublishing = false,
    super.key,
  });

  final bool isPublishing;
  final void Function()? onPublish;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      key: const ValueKey<String>('publish-button-view'),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          PublishStage(
            child: Icon(
              Icons.public_rounded,
              size: 72,
              color: CaboTheme.m3Primary,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            l10n.publishDialogReadyToPublish,
            textAlign: TextAlign.center,
            style: CaboTheme.headlineMediumStyle.copyWith(
              color: CaboTheme.onSurface,
            ),
          ),
          const SizedBox(height: 32),
          CaboPrimaryButton(
            label: l10n.publishDialogPublish,
            onPressed: isPublishing ? null : onPublish,
            leading: Icon(
              Icons.cloud_upload_rounded,
              size: 24,
              color: CaboTheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
