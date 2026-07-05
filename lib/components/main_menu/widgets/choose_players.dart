import 'dart:ui' as ui;

import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/common/presentation/widgets/context_extensions.dart';
import 'package:cabo/components/main_menu/cubit/main_menu_cubit.dart';
import 'package:cabo/domain/player_group/data/player_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChoosePlayersScreen extends StatefulWidget {
  const ChoosePlayersScreen({super.key});

  static const int minPlayers = 2;
  static const int maxPlayers = 10;
  static const int initialPlayers = 3;

  @override
  State<ChoosePlayersScreen> createState() => _ChoosePlayersScreenState();
}

class _ChoosePlayersScreenState extends State<ChoosePlayersScreen> {
  final List<TextEditingController> _controllers = <TextEditingController>[];

  static const List<Color> _badgeColors = [
    CaboTheme.primaryContainer,
    CaboTheme.secondaryContainer,
    CaboTheme.tertiaryFixed,
  ];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < ChoosePlayersScreen.initialPlayers; i++) {
      _controllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    for (final TextEditingController controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addPlayer() {
    if (_controllers.length >= ChoosePlayersScreen.maxPlayers) {
      return;
    }
    setState(() => _controllers.add(TextEditingController()));
  }

  void _removePlayer(int index) {
    if (_controllers.length <= ChoosePlayersScreen.minPlayers) {
      return;
    }
    setState(() {
      _controllers.removeAt(index).dispose();
    });
  }

  void _applyGroup(PlayerGroup group) {
    setState(() {
      for (final TextEditingController controller in _controllers) {
        controller.dispose();
      }
      _controllers
        ..clear()
        ..addAll(
          group.playerNames.map(
            (String name) => TextEditingController(text: name),
          ),
        );
      if (_controllers.length < ChoosePlayersScreen.minPlayers) {
        for (
          int i = _controllers.length;
          i < ChoosePlayersScreen.minPlayers;
          i++
        ) {
          _controllers.add(TextEditingController());
        }
      }
    });
  }

  bool get _hasEnoughPlayers =>
      _controllers
          .where(
            (TextEditingController controller) =>
                controller.text.trim().isNotEmpty,
          )
          .length >=
      ChoosePlayersScreen.minPlayers;

  void _start(MainMenuCubit cubit) {
    final List<String> names = _controllers
        .map((TextEditingController c) => c.text)
        .toList();
    cubit.startGame(names);
  }

  @override
  Widget build(BuildContext context) {
    final MainMenuCubit cubit = context.watch<MainMenuCubit>();
    final ChoosePlayers state = cubit.state as ChoosePlayers;

    return Scaffold(
      backgroundColor: CaboTheme.background,
      appBar: AppBar(
        backgroundColor: CaboTheme.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: CaboTheme.m3Primary),
          onPressed: () => cubit.onWillPop(),
        ),
        title: Text(
          context.l10n.choosePlayersTitle,
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
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
              children: [
                _buildHero(context),
                const SizedBox(height: 24),
                if (state.recentGroups.isNotEmpty) ...[
                  _buildRecentGroups(context, state.recentGroups),
                  const SizedBox(height: 16),
                ],
                ..._buildPlayerCards(context),
                const SizedBox(height: 8),
                _buildAddPlayerButton(context),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildStartButton(context, cubit),
    );
  }

  Widget _buildHero(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/hero_background.png', fit: BoxFit.cover),
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: <Color>[Color(0x66000000), Color(0x00000000)],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  context.l10n.choosePlayersHeroTitle,
                  style: CaboTheme.headlineMediumStyle.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentGroups(BuildContext context, List<PlayerGroup> groups) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.recentPlayerGroups.toUpperCase(),
          style: CaboTheme.labelSmallStyle.copyWith(
            color: CaboTheme.onSurfaceVariant,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: groups
                .map(
                  (PlayerGroup group) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      label: Text(group.playerNames.join(', ')),
                      labelStyle: CaboTheme.labelLargeStyle.copyWith(
                        color: CaboTheme.onSurface,
                      ),
                      backgroundColor: CaboTheme.surfaceContainerLow,
                      shape: StadiumBorder(
                        side: const BorderSide(color: CaboTheme.outlineVariant),
                      ),
                      onPressed: () => _applyGroup(group),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildPlayerCards(BuildContext context) {
    final List<Widget> cards = <Widget>[];
    for (int i = 0; i < _controllers.length; i++) {
      final bool canRemove =
          _controllers.length > ChoosePlayersScreen.minPlayers;
      final Color badgeColor = _badgeColors[i % _badgeColors.length];
      cards.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            decoration: BoxDecoration(
              color: CaboTheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
              border: Border.all(color: CaboTheme.surfaceVariant),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x143D3A35),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: badgeColor,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${i + 1}',
                      style: CaboTheme.bodyLargeStyle.copyWith(
                        color: CaboTheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${context.l10n.playerLabelPrefix} ${i + 1}',
                                style: const TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: CaboTheme.outline,
                                ),
                              ),
                            ),
                            if (canRemove)
                              GestureDetector(
                                onTap: () => _removePlayer(i),
                                behavior: HitTestBehavior.opaque,
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Icon(
                                    Icons.close,
                                    size: 20,
                                    color: CaboTheme.outline,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        TextField(
                          controller: _controllers[i],
                          onChanged: (_) => setState(() {}),
                          autocorrect: false,
                          enableSuggestions: false,
                          textCapitalization: TextCapitalization.words,
                          cursorColor: CaboTheme.m3Primary,
                          style: CaboTheme.bodyMediumStyle.copyWith(
                            color: CaboTheme.onSurface,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: context.l10n.playerNameHint,
                            hintStyle: CaboTheme.bodyMediumStyle.copyWith(
                              color: CaboTheme.outlineVariant,
                            ),
                            filled: true,
                            fillColor: CaboTheme.surfaceContainer,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                CaboTheme.cardRadius,
                              ),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                CaboTheme.cardRadius,
                              ),
                              borderSide: const BorderSide(
                                color: CaboTheme.m3Primary,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return cards;
  }

  Widget _buildAddPlayerButton(BuildContext context) {
    final bool enabled = _controllers.length < ChoosePlayersScreen.maxPlayers;
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: InkWell(
        onTap: enabled ? _addPlayer : null,
        borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
        child: DottedBorderBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_circle, color: CaboTheme.outline),
                const SizedBox(width: 8),
                Text(
                  context.l10n.addPlayer,
                  style: CaboTheme.labelLargeStyle.copyWith(
                    color: CaboTheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStartButton(BuildContext context, MainMenuCubit cubit) {
    final bool canStart = _hasEnoughPlayers;
    final Color contentColor = canStart
        ? CaboTheme.onPrimaryContainer
        : CaboTheme.onPrimaryContainer.withValues(alpha: 0.4);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      color: CaboTheme.background,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: CaboTheme.primaryContainer,
              foregroundColor: CaboTheme.onPrimaryContainer,
              disabledBackgroundColor: CaboTheme.primaryContainer.withValues(
                alpha: 0.4,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
              ),
            ),
            onPressed: canStart ? () => _start(cubit) : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_arrow, color: contentColor),
                const SizedBox(width: 8),
                Text(
                  context.l10n.start,
                  style: CaboTheme.headlineMediumStyle.copyWith(
                    color: contentColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Gestrichelter Rahmen für den "Spieler hinzufügen"-Button.
class DottedBorderBox extends StatelessWidget {
  const DottedBorderBox({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(
        color: CaboTheme.outlineVariant,
        radius: CaboTheme.cardRadius,
      ),
      child: child,
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );

    final Path path = Path()..addRRect(rrect);
    const double dashWidth = 6;
    const double dashSpace = 4;

    for (final ui.PathMetric metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}
