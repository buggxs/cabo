import 'package:cabo/components/statistics/cubit/statistics_cubit.dart';
import 'package:cabo/components/statistics/widgets/title_cell.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/game/game_service.dart';
import 'package:cabo/misc/widgets/cabo_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CaboDataTable extends StatefulWidget {
  const CaboDataTable({
    super.key,
    required this.titleCells,
    required this.rounds,
    required this.cubit,
  });

  final List<TitleCell> titleCells;
  final List<Widget> rounds;
  final StatisticsCubit cubit;

  @override
  State<CaboDataTable> createState() => _CaboDataTableState();
}

class _CaboDataTableState extends State<CaboDataTable>
    with WidgetsBindingObserver {
  final ScrollController _horizontal = ScrollController(),
      _vertical = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _horizontal,
          scrollDirection: Axis.horizontal,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Sticky header
              Material(
                elevation: _vertical.hasClients && _vertical.offset > 0 ? 2 : 0,
                color: CaboTheme.secondaryBackgroundColor,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: widget.titleCells,
                ),
              ),
              // Scrollable content
              Flexible(
                child: SingleChildScrollView(
                  controller: _vertical,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: widget.rounds,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      widget.cubit.client?.deactivate();
      DateTime finishedAt = DateTime.now();
      app<GameService>().saveToGameHistory(
        widget.cubit.state.game!.copyWith(
          finishedAt: DateFormat('dd-MM-yyyy HH:mm').format(finishedAt),
        ),
      );
    }
  }

  @override
  void dispose() {
    _horizontal.dispose();
    _vertical.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
