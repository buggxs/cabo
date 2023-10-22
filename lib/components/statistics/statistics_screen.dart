import 'package:cabo/components/statistics/cubit/statistics_cubit.dart';
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
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(),
                            ),
                          ),
                          width: 115,
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Player 1',
                                    style: title,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('2'),
                                      Text('23'),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 115,
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Player 1',
                                    style: title,
                                  ),
                                  SizedBox(
                                    width: 50,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('2'),
                                        Text('23'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 115,
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Player 1',
                                    style: title,
                                  ),
                                  SizedBox(
                                    width: 50,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('2'),
                                        Text('23'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
