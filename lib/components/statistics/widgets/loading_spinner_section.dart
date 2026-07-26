import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/components/statistics/widgets/publish_stage.dart';
import 'package:flutter/material.dart';

class LoadingSpinnerSection extends StatelessWidget {
  const LoadingSpinnerSection({this.loadingText, super.key});

  final String? loadingText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const ValueKey<String>('loading-view'),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          PublishStage(
            child: CircularProgressIndicator(color: CaboTheme.m3Primary),
          ),
          if (loadingText != null) ...<Widget>[
            const SizedBox(height: 32),
            Text(
              loadingText!,
              textAlign: TextAlign.center,
              style: CaboTheme.bodyLargeStyle.copyWith(
                color: CaboTheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
