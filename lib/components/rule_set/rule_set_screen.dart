import 'package:cabo/components/main_menu/widgets/dark_screen_overlay.dart';
import 'package:cabo/components/main_menu/widgets/menu_button.dart';
import 'package:cabo/components/rule_set/cubit/rule_set_cubit.dart';
import 'package:cabo/domain/rule_set/data/rule_set.dart';
import 'package:cabo/misc/widgets/cabo_switch.dart';
import 'package:cabo/misc/widgets/cabo_text_field.dart';
import 'package:cabo/misc/widgets/cabo_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

class RuleSetScreenContent extends StatelessWidget {
  const RuleSetScreenContent({super.key});

  static const route = 'rule_set_screen';

  @override
  Widget build(BuildContext context) {
    RuleSetCubit cubit = context.watch<RuleSetCubit>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: CaboTheme.primaryColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Rules',
          style: CaboTheme.primaryTextStyle.copyWith(
            fontSize: 38,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/cabo-main-menu-background.png'),
            fit: BoxFit.cover,
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: DarkScreenOverlay(
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48.0,
                    vertical: 6,
                  ),
                  child: CaboTextField(
                    value: cubit.state.ruleSet.totalGamePoints.toString(),
                    labelText: AppLocalizations.of(context)!
                        .ruleScreenTotalGamePointsLabel,
                    onChanged: (String points) {
                      cubit.saveRuleSet(
                        cubit.state.ruleSet.copyWith(
                          totalGamePoints: int.tryParse(points),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48.0,
                    vertical: 6,
                  ),
                  child: CaboTextField(
                    value: cubit.state.ruleSet.kamikazePoints.toString(),
                    labelText: AppLocalizations.of(context)!
                        .ruleScreenKamikazePointsLabel,
                    onChanged: (String points) {
                      final RuleSet ruleSet = cubit.state.ruleSet.copyWith(
                        kamikazePoints: int.tryParse(points),
                      );
                      cubit.saveRuleSet(
                        ruleSet,
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48.0,
                    vertical: 6,
                  ),
                  child: CaboSwitch(
                    initialValue: cubit.state.ruleSet.roundWinnerGetsZeroPoints,
                    labelText:
                        AppLocalizations.of(context)!.ruleScreenZeroPointsLabel,
                    onChanged: (bool value) {
                      cubit.saveRuleSet(
                        cubit.state.ruleSet.copyWith(
                          roundWinnerGetsZeroPoints: value,
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48.0,
                    vertical: 6,
                  ),
                  child: CaboSwitch(
                    initialValue: cubit.state.ruleSet.precisionLanding,
                    labelText: AppLocalizations.of(context)!
                        .ruleScreenPrecisionLandingLabel,
                    onChanged: (bool value) {
                      final RuleSet ruleSet = cubit.state.ruleSet.copyWith(
                        precisionLanding: value,
                      );
                      cubit.saveRuleSet(
                        ruleSet,
                      );
                    },
                  ),
                ),
                MenuButton(
                  text: AppLocalizations.of(context)!.ruleScreenSaveButton,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48.0,
                    vertical: 6,
                  ),
                  onTap: () => Navigator.of(context).pop(),
                ),
                MenuButton(
                  text:
                      AppLocalizations.of(context)!.ruleScreenResetRulesButton,
                  textStyle: CaboTheme.primaryTextStyle.copyWith(
                    color: CaboTheme.tertiaryColor,
                    fontSize: 24,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48.0,
                    vertical: 6,
                  ),
                  innerPadding: const EdgeInsets.all(2),
                  onTap: cubit.resetRuleSet,
                ),
                const SizedBox(
                  height: 25,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
