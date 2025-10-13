import 'package:cabo/common/presentation/widgets/cabo_switch.dart';
import 'package:cabo/common/presentation/widgets/cabo_text_field.dart';
import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/common/presentation/widgets/context_extensions.dart';
import 'package:cabo/common/presentation/widgets/dark_screen_overlay.dart';
import 'package:cabo/components/application/cubit/application_cubit.dart';
import 'package:cabo/components/main_menu/widgets/menu_button.dart';
import 'package:cabo/components/rule_set/cubit/rule_set_cubit.dart';
import 'package:cabo/components/rule_set/widgets/rule_set_info.dart';
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

class RuleSetScreenContent extends StatelessWidget {
  const RuleSetScreenContent({super.key});

  static const route = 'rule_set_screen';

  @override
  Widget build(BuildContext context) {
    RuleSetCubit cubit = context.watch<RuleSetCubit>();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController totalGamePointsController =
        TextEditingController(
          text: cubit.state.ruleSet.totalGamePoints.toString(),
        );
    final TextEditingController kamikazePointsController =
        TextEditingController(
          text: cubit.state.ruleSet.kamikazePoints.toString(),
        );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: CaboTheme.primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const TapableTitle(),
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
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48.0,
                      vertical: 6,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: CaboTextFormField(
                            controller: totalGamePointsController,
                            labelText: AppLocalizations.of(
                              context,
                            )!.ruleScreenTotalGamePointsLabel,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: RuleInfo(
                            info: AppLocalizations.of(
                              context,
                            )!.ruleScreenTotalPointsHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48.0,
                      vertical: 6,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: CaboTextFormField(
                            controller: kamikazePointsController,
                            labelText: AppLocalizations.of(
                              context,
                            )!.ruleScreenKamikazePointsLabel,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: RuleInfo(
                            info: AppLocalizations.of(
                              context,
                            )!.ruleScreenKamikazeHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48.0,
                      vertical: 6,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: CaboSwitch(
                            initialValue:
                                cubit.state.ruleSet.roundWinnerGetsZeroPoints,
                            labelText: AppLocalizations.of(
                              context,
                            )!.ruleScreenZeroPointsLabel,
                            onChanged: (bool value) {
                              cubit.saveRuleSet(
                                cubit.state.ruleSet.copyWith(
                                  roundWinnerGetsZeroPoints: value,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: RuleInfo(
                            info: AppLocalizations.of(
                              context,
                            )!.ruleScreenRoundWinnerHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48.0,
                      vertical: 6,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: CaboSwitch(
                            initialValue: cubit.state.ruleSet.precisionLanding,
                            labelText: AppLocalizations.of(
                              context,
                            )!.ruleScreenPrecisionLandingLabel,
                            onChanged: (bool value) {
                              final RuleSet ruleSet = cubit.state.ruleSet
                                  .copyWith(precisionLanding: value);
                              cubit.saveRuleSet(ruleSet);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: RuleInfo(
                            info: AppLocalizations.of(
                              context,
                            )!.ruleScreenExactly100Hint,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  MenuFormButton(
                    text: AppLocalizations.of(context)!.ruleScreenSaveButton,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48.0,
                      vertical: 6,
                    ),
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        cubit.saveRuleSet(
                          cubit.state.ruleSet.copyWith(
                            totalGamePoints: int.tryParse(
                              totalGamePointsController.text,
                            ),
                            kamikazePoints: int.tryParse(
                              kamikazePointsController.text,
                            ),
                          ),
                        );
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  MenuButton(
                    text: AppLocalizations.of(
                      context,
                    )!.ruleScreenResetRulesButton,
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
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TapableTitle extends StatefulWidget {
  const TapableTitle({Key? key}) : super(key: key);

  @override
  TapableTitleState createState() => TapableTitleState();
}

class TapableTitleState extends State<TapableTitle> {
  int _tapCount = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _tapCount++;
        });
        if (_tapCount == 9) {
          context.read<ApplicationCubit>().toggleDeveloperMode();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.developerModeToggled),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      },
      child: Text(
        AppLocalizations.of(context)!.ruleScreenTitle,
        style: CaboTheme.primaryTextStyle.copyWith(fontSize: 38),
      ),
    );
  }
}
