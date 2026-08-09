import 'package:cabo/common/presentation/widgets/cabo_primary_button.dart';
import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/core/app_navigator/navigation_service.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/announcement/announcement.dart';
import 'package:cabo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class AnnouncementDialog extends StatelessWidget {
  const AnnouncementDialog({super.key, required this.announcement});

  final Announcement announcement;

  static const int _maxActions = 2;

  static Future<void> show({required Announcement announcement}) {
    return app<NavigationService>().showAppDialog(
      dialog: (BuildContext context) => Dialog(
        backgroundColor: CaboTheme.surfaceContainerLowest,
        insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: AnnouncementDialog(announcement: announcement),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final bool isEnglish = Localizations.localeOf(context).languageCode == 'en';
    final String title = isEnglish
        ? announcement.title.en
        : announcement.title.de;
    final String message = isEnglish
        ? announcement.message.en
        : announcement.message.de;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildHeader(),
          const SizedBox(height: 20),
          Text(
            title,
            style: CaboTheme.headlineMediumStyle.copyWith(
              color: CaboTheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: CaboTheme.bodyLargeStyle.copyWith(
              color: CaboTheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          _buildActions(context, l10n, isEnglish),
        ],
      ),
    );
  }

  Widget _buildActions(
    BuildContext context,
    AppLocalizations l10n,
    bool isEnglish,
  ) {
    final List<AnnouncementAction> actions =
        announcement.actions?.take(_maxActions).toList() ??
        <AnnouncementAction>[];

    if (actions.isEmpty) {
      return SizedBox(
        width: double.infinity,
        child: CaboPrimaryButton(
          label: l10n.announcementDialogOkayButton,
          onPressed: () => Navigator.of(context).pop(),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: double.infinity,
          child: CaboPrimaryButton(
            label: _label(actions.first, isEnglish),
            onPressed: () => _onActionPressed(context, actions.first),
          ),
        ),
        if (actions.length > 1) ...<Widget>[
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => _onActionPressed(context, actions[1]),
            child: Text(
              _label(actions[1], isEnglish),
              style: CaboTheme.labelLargeStyle.copyWith(
                color: CaboTheme.onSurfaceVariant,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ],
    );
  }

  String _label(AnnouncementAction action, bool isEnglish) =>
      isEnglish ? action.label.en : action.label.de;

  void _onActionPressed(BuildContext context, AnnouncementAction action) {
    Navigator.of(context).pop();

    if (action.type != AnnouncementActionType.navigate) {
      return;
    }

    app<NavigationService>().pushAnnouncementRoute(action.route);
  }

  Widget _buildHeader() {
    final String? imageUrl = announcement.imageUrl;
    if (imageUrl == null) {
      return _buildIcon();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
      child: _AnnouncementImage(imageUrl: imageUrl, fallback: _buildIcon()),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: CaboTheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.campaign_rounded,
        size: 32,
        color: CaboTheme.onPrimaryContainer,
      ),
    );
  }
}

class _AnnouncementImage extends StatefulWidget {
  const _AnnouncementImage({required this.imageUrl, required this.fallback});

  final String imageUrl;
  final Widget fallback;

  @override
  State<_AnnouncementImage> createState() => _AnnouncementImageState();
}

class _AnnouncementImageState extends State<_AnnouncementImage> {
  bool _isImageVisible = false;

  void _markImageVisible() {
    if (_isImageVisible) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _isImageVisible = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const Duration fadeDuration = Duration(milliseconds: 200);

    return SizedBox(
      width: double.infinity,
      height: 160,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          AnimatedOpacity(
            opacity: _isImageVisible ? 0 : 1,
            duration: fadeDuration,
            child: Center(child: widget.fallback),
          ),
          Image.network(
            widget.imageUrl,
            fit: BoxFit.cover,
            frameBuilder:
                (
                  BuildContext context,
                  Widget child,
                  int? frame,
                  bool wasSynchronouslyLoaded,
                ) {
                  final bool isReady = frame != null || wasSynchronouslyLoaded;
                  if (isReady) {
                    _markImageVisible();
                  }
                  return AnimatedOpacity(
                    opacity: isReady ? 1 : 0,
                    duration: fadeDuration,
                    curve: Curves.easeOut,
                    child: child,
                  );
                },
            errorBuilder: (BuildContext context, Object error, StackTrace? _) =>
                const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
