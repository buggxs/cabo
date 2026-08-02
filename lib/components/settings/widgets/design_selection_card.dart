import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/common/presentation/widgets/context_extensions.dart';
import 'package:cabo/components/application/cubit/application_cubit.dart';
import 'package:cabo/domain/application/app_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DesignSelectionCard extends StatelessWidget {
  const DesignSelectionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final AppDesign design = context.watch<ApplicationCubit>().state.design;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: CaboTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CaboTheme.outlineVariant),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x143D3A35),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            context.l10n.designSectionTitle,
            textAlign: TextAlign.center,
            style: CaboTheme.headlineMediumStyle.copyWith(
              color: CaboTheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.designSectionSubtitle.toUpperCase(),
            textAlign: TextAlign.center,
            style: CaboTheme.labelSmallStyle.copyWith(
              color: CaboTheme.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 20),
          SegmentedButton<AppDesign>(
            segments: <ButtonSegment<AppDesign>>[
              ButtonSegment<AppDesign>(
                value: AppDesign.modern,
                label: Text(context.l10n.designModern),
                icon: const Icon(Icons.light_mode_outlined),
              ),
              ButtonSegment<AppDesign>(
                value: AppDesign.classic,
                label: Text(context.l10n.designClassic),
                icon: const Icon(Icons.forest_outlined),
              ),
            ],
            selected: <AppDesign>{design},
            showSelectedIcon: false,
            onSelectionChanged: (Set<AppDesign> selection) {
              context.read<ApplicationCubit>().saveDesign(selection.first);
            },
          ),
          const SizedBox(height: 12),
          Text(
            design == AppDesign.classic
                ? context.l10n.designClassicDescription
                : context.l10n.designModernDescription,
            textAlign: TextAlign.center,
            style: CaboTheme.bodyMediumStyle.copyWith(
              color: CaboTheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
