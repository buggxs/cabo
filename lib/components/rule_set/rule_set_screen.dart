import 'package:cabo/common/presentation/widgets/cabo_primary_button.dart';
import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/components/rule_set/cubit/rule_set_cubit.dart';
import 'package:cabo/domain/rule_set/data/rule_set.dart';
import 'package:cabo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RuleSetScreen extends StatelessWidget {
  const RuleSetScreen({super.key});

  static const route = 'rule_set_screen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RuleSetCubit()..loadRuleSet(),
      child: const RuleSetScreenContent(),
    );
  }
}

class RuleSetScreenContent extends StatefulWidget {
  const RuleSetScreenContent({super.key});

  @override
  State<RuleSetScreenContent> createState() => _RuleSetScreenContentState();
}

class _RuleSetScreenContentState extends State<RuleSetScreenContent> {
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
    final AppLocalizations l10n = AppLocalizations.of(context)!;
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
      child: _buildScaffold(context, l10n, cubit, ruleSet),
    );
  }

  Widget _buildScaffold(
    BuildContext context,
    AppLocalizations l10n,
    RuleSetCubit cubit,
    RuleSet ruleSet,
  ) {
    return Scaffold(
      backgroundColor: CaboTheme.scaffoldBackground,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CaboTheme.scaffoldBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: CaboTheme.m3Primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.ruleScreenTitle,
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
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: <Widget>[
                  _buildSectionHeader(l10n.ruleScreenScoreSection),
                  const SizedBox(height: 16),
                  _buildNumberCard(
                    title: l10n.ruleScreenTotalGamePointsLabel,
                    description: l10n.ruleScreenTotalPointsDescription,
                    suffix: l10n.ruleScreenPointsSuffix,
                    controller: _totalGamePointsController,
                  ),
                  const SizedBox(height: 16),
                  _buildNumberCard(
                    title: l10n.ruleScreenKamikazePointsLabel,
                    description: l10n.ruleScreenKamikazeDescription,
                    suffix: l10n.ruleScreenPointsSuffix,
                    controller: _kamikazePointsController,
                  ),
                  const SizedBox(height: 24),
                  _buildSectionHeader(l10n.ruleScreenMechanicsSection),
                  const SizedBox(height: 16),
                  _buildToggleCard(
                    title: l10n.ruleScreenZeroPointsLabel,
                    description: l10n.ruleScreenZeroPointsDescription,
                    value: ruleSet.roundWinnerGetsZeroPoints,
                    onChanged: (bool value) => cubit.saveRuleSet(
                      ruleSet.copyWith(roundWinnerGetsZeroPoints: value),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildToggleCard(
                    title: l10n.ruleScreenPrecisionLandingLabel,
                    description: l10n.ruleScreenPrecisionLandingDescription,
                    value: ruleSet.precisionLanding,
                    onChanged: (bool value) => cubit.saveRuleSet(
                      ruleSet.copyWith(precisionLanding: value),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildInfoCard(l10n.ruleScreenInfoCard),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CaboPrimaryButton(
                label: l10n.ruleScreenSaveButton,
                leading: Icon(Icons.save, color: CaboTheme.onPrimaryContainer),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    cubit.saveRuleSet(
                      ruleSet.copyWith(
                        totalGamePoints: int.tryParse(
                          _totalGamePointsController.text,
                        ),
                        kamikazePoints: int.tryParse(
                          _kamikazePointsController.text,
                        ),
                      ),
                    );
                    Navigator.of(context).pop();
                  }
                },
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
      ),
    );
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

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CaboTheme.surfaceContainerLowest,
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
      child: child,
    );
  }

  Widget _buildNumberCard({
    required String title,
    required String description,
    required String suffix,
    required TextEditingController controller,
  }) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: CaboTheme.bodyLargeStyle.copyWith(
              color: CaboTheme.m3Primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: CaboTheme.labelSmallStyle.copyWith(
              color: CaboTheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            cursorColor: CaboTheme.m3Primary,
            style: CaboTheme.headlineMediumStyle.copyWith(
              color: CaboTheme.onSurface,
            ),
            validator: (String? value) {
              if (value == null || int.tryParse(value) == null) {
                return '';
              }
              return null;
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: CaboTheme.surfaceContainer,
              suffixText: suffix,
              suffixStyle: CaboTheme.labelLargeStyle.copyWith(
                color: CaboTheme.onSurfaceVariant,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
                borderSide: BorderSide(
                  color: CaboTheme.primaryContainer,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
                borderSide: BorderSide(color: CaboTheme.m3Error),
              ),
              errorStyle: const TextStyle(height: 0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleCard({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return _buildCard(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: CaboTheme.bodyLargeStyle.copyWith(
                    color: CaboTheme.m3Primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: CaboTheme.labelSmallStyle.copyWith(
                    color: CaboTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: CaboTheme.onSecondary,
            activeTrackColor: CaboTheme.m3Secondary,
            inactiveThumbColor: CaboTheme.surfaceContainerLowest,
            inactiveTrackColor: CaboTheme.surfaceVariant,
            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
          ),
        ],
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
