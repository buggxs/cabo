import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/components/main_menu/widgets/menu_button.dart';
import 'package:cabo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class PublishGameSection extends StatelessWidget {
  const PublishGameSection({
    required this.onPublish,
    this.isPublishing = false,
    Key? key,
  }) : super(key: key);

  final bool isPublishing;
  final void Function()? onPublish;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey<String>('publish-button-view'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            AppLocalizations.of(context)!.publishDialogReadyToPublish,
            textAlign: TextAlign.center,
            style: CaboTheme.primaryTextStyle.copyWith(fontSize: 26),
          ),
        ),
        const SizedBox(height: 20),
        MenuButton(
          text: AppLocalizations.of(context)!.publishDialogPublish,
          onTap: isPublishing ? null : onPublish,
          textStyle: CaboTheme.primaryTextStyle.copyWith(fontSize: 18),
        ),
      ],
    );
  }
}
