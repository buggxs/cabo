import 'dart:math' as math;

import 'package:cabo/common/presentation/widgets/cabo_primary_button.dart';
import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/common/presentation/widgets/context_extensions.dart';
import 'package:cabo/components/about/cubit/about_cubit.dart';
import 'package:cabo/components/about/widgets/debug_test_section.dart';
import 'package:cabo/components/about/widgets/feedback_card.dart';
import 'package:cabo/components/application/cubit/application_cubit.dart';
import 'package:cabo/core/app_navigator/navigation_service.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/rating/rating_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const String route = 'about_screen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AboutCubit>(
      create: (BuildContext _) => AboutCubit(),
      child: const _AboutScreenContent(),
    );
  }
}

class _AboutScreenContent extends StatefulWidget {
  const _AboutScreenContent();

  @override
  State<_AboutScreenContent> createState() => _AboutScreenContentState();
}

class _AboutScreenContentState extends State<_AboutScreenContent> {
  int _copyrightTapCount = 0;

  void _handleCopyrightTap() {
    setState(() {
      _copyrightTapCount++;
    });
    if (_copyrightTapCount < 7) {
      return;
    }
    _copyrightTapCount = 0;
    context.read<ApplicationCubit>().toggleDeveloperMode();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.developerModeToggled),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CaboTheme.scaffoldBackground,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CaboTheme.scaffoldBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: CaboTheme.m3Primary),
          onPressed: () => app<NavigationService>().pop(),
        ),
        title: Text(
          context.l10n.aboutScreenTitle,
          style: CaboTheme.headlineMediumStyle.copyWith(
            color: CaboTheme.m3Primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 576),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: <Widget>[
                _buildRatingHero(context),
                const SizedBox(height: 32),
                const FeedbackCard(),
                const SizedBox(height: 32),
                _buildFunFactCard(context),
                const SizedBox(height: 24),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _handleCopyrightTap,
                  child: Text(
                    '© Andre Müller ${DateTime.now().year}',
                    textAlign: TextAlign.center,
                    style: CaboTheme.labelSmallStyle.copyWith(
                      color: CaboTheme.onSurfaceVariant,
                    ),
                  ),
                ),
                if (kDebugMode) ...<Widget>[
                  const SizedBox(height: 24),
                  const DebugTestSection(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingHero(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildRatingBadge(),
        const SizedBox(height: 16),
        Text(
          context.l10n.aboutScreenRatingHeadline,
          textAlign: TextAlign.center,
          style: CaboTheme.headlineMediumStyle.copyWith(
            color: CaboTheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 280),
          child: Text(
            context.l10n.aboutScreenRatingDescription,
            textAlign: TextAlign.center,
            style: CaboTheme.bodyMediumStyle.copyWith(
              color: CaboTheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 240,
          child: CaboPrimaryButton(
            label: context.l10n.aboutScreenRatingButton,
            onPressed: () => app<RatingService>().openStoreListing(),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingBadge() {
    return SizedBox(
      width: 128,
      height: 128,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Transform.rotate(
            angle: 6 * math.pi / 180,
            child: Container(
              decoration: BoxDecoration(
                color: CaboTheme.primaryFixedDim.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: CaboTheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: CaboTheme.outlineVariant),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Color(0x143D3A35),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Icon(Icons.star, size: 64, color: CaboTheme.m3Primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFunFactCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CaboTheme.isClassic
            ? CaboTheme.surfaceContainerHigh
            : const Color(0xFFFFFCEB),
        borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
        border: Border.all(color: CaboTheme.outlineVariant),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x143D3A35),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.lightbulb_outline, color: CaboTheme.m3Tertiary),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              context.l10n.aboutScreenFunFact,
              style: CaboTheme.labelSmallStyle.copyWith(
                color: CaboTheme.m3Tertiary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
