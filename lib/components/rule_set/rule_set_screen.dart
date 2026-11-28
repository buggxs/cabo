import 'dart:async';

import 'package:cabo/common/presentation/widgets/cabo_primary_button.dart';
import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/components/rule_set/cubit/rule_set_cubit.dart';
import 'package:cabo/components/rule_set/widgets/rule_number_card.dart';
import 'package:cabo/components/rule_set/widgets/rule_toggle_card.dart';
import 'package:cabo/core/app_navigator/navigation_service.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/rule_set/data/rule_set.dart';
import 'package:cabo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cabo/common/presentation/widgets/context_extensions.dart';

class RuleSetScreen extends StatelessWidget {
  const RuleSetScreen({super.key});

  static const String route = 'rule_set_screen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RuleSetCubit>(
      create: (BuildContext _) {
        final RuleSetCubit cubit = RuleSetCubit();
        unawaited(cubit.loadRuleSet());
        return cubit;
      },
      child: const _RuleSetScreenContent(),
    );
  }
}

class _RuleSetScreenContent extends StatefulWidget {
  const _RuleSetScreenContent();

  @override
  State<_RuleSetScreenContent> createState() => _RuleSetScreenContentState();
}

class _RuleSetScreenContentState extends State<_RuleSetScreenContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _totalGamePointsController;
  late final TextEditingController _kamikazePointsController;

  @override
  void initState() {
    super.initState();
    final RuleSet ruleSet = context.read<RuleSetCubit>().state.ruleSet;
    _totalGamePointsController = TextEditingController(
      text: ruleSet.totalGamePoints.toString(),
    );
    _kamikazePointsController = TextEditingController(
      text: ruleSet.kamikazePoints.toString(),
    );
  }

  @override
  void dispose() {
    _totalGamePointsController.dispose();
    _kamikazePointsController.dispose();
    super.dispose();
  }

  void _syncControllers(RuleSet ruleSet) {
    _totalGamePointsController.text = ruleSet.totalGamePoints.toString();
    _kamikazePointsController.text = ruleSet.kamikazePoints.toString();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final RuleSetCubit cubit = context.watch<RuleSetCubit>();
    final RuleSet ruleSet = cubit.state.ruleSet;

    return BlocListener<RuleSetCubit, RuleSetState>(
      // Only sync the text fields when the persisted point values change
      // (initial load or reset), so unsaved input survives toggle rebuilds.
      listenWhen: (RuleSetState previous, RuleSetState current) =>
          previous.ruleSet.totalGamePoints != current.ruleSet.totalGamePoints ||
          previous.ruleSet.kamikazePoints != current.ruleSet.kamikazePoints,
      listener: (BuildContext context, RuleSetState state) =>
          _syncControllers(state.ruleSet),
      child: _buildScaffold(l10n, cubit, ruleSet),
    );
  }

  Widget _buildScaffold(
    AppLocalizations l10n,
    RuleSetCubit cubit,
    RuleSet ruleSet,
  ) {
    return Scaffold(
      backgroundColor: CaboTheme.scaffoldBackground,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(l10n),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 576),
            child: Form(
              key: _formKey,
              child: _buildRuleList(l10n, cubit, ruleSet),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomActions(l10n, cubit, ruleSet),
    );
  }

  PreferredSizeWidget _buildAppBar(AppLocalizations l10n) {
    return AppBar(
      centerTitle: true,
      backgroundColor: CaboTheme.scaffoldBackground,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: CaboTheme.m3Primary),
        onPressed: () => app<NavigationService>().pop(),
      ),
      title: Text(
        l10n.ruleScreenTitle,
        style: CaboTheme.headlineMediumStyle.copyWith(
          color: CaboTheme.m3Primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRuleList(
    AppLocalizations l10n,
    RuleSetCubit cubit,
    RuleSet ruleSet,
  ) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: <Widget>[
        _buildSectionHeader(l10n.ruleScreenScoreSection),
        const SizedBox(height: 16),
        RuleNumberCard(
          title: l10n.ruleScreenTotalGamePointsLabel,
          description: l10n.ruleScreenTotalPointsDescription,
          suffix: l10n.ruleScreenPointsSuffix,
          controller: _totalGamePointsController,
        ),
        const SizedBox(height: 16),
        RuleNumberCard(
          title: l10n.ruleScreenKamikazePointsLabel,
          description: l10n.ruleScreenKamikazeDescription,
          suffix: l10n.ruleScreenPointsSuffix,
          controller: _kamikazePointsController,
          // A hand can never exceed 50 points, a higher value would
          // silently disable the rule.
          maxValue: 50,
        ),
        const SizedBox(height: 24),
        _buildSectionHeader(l10n.ruleScreenMechanicsSection),
        const SizedBox(height: 16),
        RuleToggleCard(
          title: l10n.ruleScreenZeroPointsLabel,
          description: l10n.ruleScreenZeroPointsDescription,
          isEnabled: ruleSet.shouldRoundWinnerGetZeroPoints,
          onChanged: (bool isEnabled) => cubit.saveRuleSet(
            ruleSet.copyWith(shouldRoundWinnerGetZeroPoints: isEnabled),
          ),
        ),
        const SizedBox(height: 16),
        RuleToggleCard(
          title: l10n.ruleScreenPrecisionLandingLabel,
          description: l10n.ruleScreenPrecisionLandingDescription,
          isEnabled: ruleSet.hasPrecisionLanding,
          onChanged: (bool isEnabled) => cubit.saveRuleSet(
            ruleSet.copyWith(hasPrecisionLanding: isEnabled),
          ),
        ),
        const SizedBox(height: 24),
        _buildInfoCard(l10n.ruleScreenInfoCard),
      ],
    );
  }

  Widget _buildBottomActions(
    AppLocalizations l10n,
    RuleSetCubit cubit,
    RuleSet ruleSet,
  ) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CaboPrimaryButton(
              label: l10n.ruleScreenSaveButton,
              leading: Icon(Icons.save, color: CaboTheme.onPrimaryContainer),
              onPressed: () => _saveAndClose(cubit, ruleSet),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: CaboTheme.m3Secondary,
                  side: BorderSide(
                    color: CaboTheme.m3Secondary.withValues(alpha: 0.2),
                    width: 2,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
                  ),
                ),
                onPressed: cubit.resetRuleSet,
                child: Text(
                  l10n.ruleScreenResetRulesButton,
                  style: CaboTheme.labelLargeStyle.copyWith(
                    color: CaboTheme.m3Secondary,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveAndClose(RuleSetCubit cubit, RuleSet ruleSet) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    unawaited(
      cubit.saveRuleSet(
        ruleSet.copyWith(
          totalGamePoints: int.tryParse(_totalGamePointsController.text),
          kamikazePoints: int.tryParse(_kamikazePointsController.text),
        ),
      ),
    );
    app<NavigationService>().pop();
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: CaboTheme.labelLargeStyle.copyWith(
        color: CaboTheme.onSurfaceVariant,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildInfoCard(String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CaboTheme.secondaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CaboTheme.m3Secondary.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.info_outline, color: CaboTheme.m3Secondary),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: CaboTheme.labelLargeStyle.copyWith(
                color: CaboTheme.onSecondaryFixedVariant,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
