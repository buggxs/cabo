import 'package:cabo/components/main_menu/widgets/dark_screen_overlay.dart';
import 'package:cabo/components/main_menu/widgets/menu_button.dart';
import 'package:cabo/misc/utils/dialogs.dart';
import 'package:cabo/misc/widgets/cabo_theme.dart';
import 'package:flutter/material.dart';

class RuleSetScreen extends StatelessWidget {
  const RuleSetScreen({super.key});

  static const route = 'rule_set_screen';

  @override
  Widget build(BuildContext context) {
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
          onPressed: () => {},
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48.0,
                    vertical: 6,
                  ),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (String points) {},
                    minLines: 1,
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Aclonica',
                      color: CaboTheme.primaryColor,
                    ),
                    decoration: dialogPointInputStyle.copyWith(
                        labelStyle: CaboTheme.secondaryTextStyle.copyWith(
                          fontSize: 14,
                          color: CaboTheme.primaryColor,
                          backgroundColor: CaboTheme.tertiaryColor,
                        ),
                        labelText: 'Max. Game Points'),
                  ),
                ),
                MenuButton(
                  text: 'Save',
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48.0,
                    vertical: 6,
                  ),
                ),
                MenuButton(
                  text: 'Reset Settings',
                  textStyle: CaboTheme.primaryTextStyle.copyWith(
                    color: CaboTheme.tertiaryColor,
                    fontSize: 24,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48.0,
                    vertical: 6,
                  ),
                  innerPadding: EdgeInsets.all(2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
