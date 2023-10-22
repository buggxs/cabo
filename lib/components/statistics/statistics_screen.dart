import 'package:cabo/components/statistics/cubit/statistics_cubit.dart';
import 'package:cabo/components/statistics/widgets/input_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  static const String route = 'statistics_screen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StatisticsCubit>(
      create: (_) => StatisticsCubit(),
      child: StatisticsScreenContent(),
    );
  }
}

class StatisticsScreenContent extends StatelessWidget {
  StatisticsScreenContent({Key? key}) : super(key: key);

  final TextStyle title = const TextStyle(
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.bold,
    fontSize: 22,
  );

  final InputDecoration inputDecoration = const InputDecoration(
    border: InputBorder.none,
  );

  final FocusNode name1 = FocusNode();
  final FocusNode name2 = FocusNode();
  final FocusNode name3 = FocusNode();

  @override
  Widget build(BuildContext context) {
    StatisticsCubit cubit = context.watch<StatisticsCubit>();
    StatisticsState state = cubit.state;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/cabo_bg_upscaled.png'),
          fit: BoxFit.cover,
        ),
      ),
      constraints: const BoxConstraints.expand(),
      child: SafeArea(
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(12.0),
            color: const Color.fromRGBO(90, 220, 51, 0.6509803921568628),
            shadowColor: Colors.black,
            elevation: 5.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: DataTable(
                columns: [
                  DataColumn(
                    label: Flexible(
                      child: TextFormField(
                        style: title,
                        focusNode: name1,
                        decoration: inputDecoration,
                        initialValue: 'Andre',
                        keyboardType: TextInputType.name,
                        onFieldSubmitted: (String val) {
                          if (val.isNotEmpty) {
                            name1.unfocus();
                            FocusScope.of(context).requestFocus(name2);
                          }
                        },
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Flexible(
                      child: TextFormField(
                        style: title,
                        focusNode: name2,
                        decoration: inputDecoration,
                        initialValue: 'Michi',
                        keyboardType: TextInputType.name,
                        onFieldSubmitted: (String val) {
                          if (val.isNotEmpty) {
                            name2.unfocus();
                            FocusScope.of(context).requestFocus(name3);
                          }
                        },
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Flexible(
                      child: TextFormField(
                        style: title,
                        focusNode: name3,
                        decoration: inputDecoration,
                        initialValue: 'Pascal',
                        keyboardType: TextInputType.name,
                        onFieldSubmitted: (String val) {
                          if (val.isNotEmpty) {
                            name3.unfocus();
                          }
                        },
                      ),
                    ),
                  ),
                ],
                rows: [
                  DataRow(
                    cells: <DataCell>[
                      DataCell(
                        InputCell(
                          textStyle: title,
                          inputDecoration: inputDecoration,
                          increaseFunction: cubit.increaseSum,
                          playerType: PlayerType.playerOne,
                        ),
                      ),
                      DataCell(
                        InputCell(
                          textStyle: title,
                          inputDecoration: inputDecoration,
                          increaseFunction: cubit.increaseSum,
                          playerType: PlayerType.playerTwo,
                        ),
                      ),
                      DataCell(
                        InputCell(
                          textStyle: title,
                          inputDecoration: inputDecoration,
                          increaseFunction: cubit.increaseSum,
                          playerType: PlayerType.playerThree,
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text(
                        '${state.sumPlayerOne}',
                        style: title,
                      )),
                      DataCell(Text(
                        '${state.sumPlayerTwo}',
                        style: title,
                      )),
                      DataCell(Text(
                        '${state.sumPlayerThree}',
                        style: title,
                      )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
