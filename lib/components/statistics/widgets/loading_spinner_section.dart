import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:flutter/material.dart';

class LoadingSpinnerSection extends StatelessWidget {
  const LoadingSpinnerSection({this.loadingText, Key? key}) : super(key: key);

  final String? loadingText;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey<String>('loading-view'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const CircularProgressIndicator(color: CaboTheme.primaryColor),
        const SizedBox(height: 20),
        if (loadingText != null) ...[
          Text(
            loadingText!,
            textAlign: TextAlign.center,
            style: CaboTheme.primaryTextStyle.copyWith(fontSize: 22),
          ),
        ],
      ],
    );
  }
}
