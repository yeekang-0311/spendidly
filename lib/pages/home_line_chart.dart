import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../model/transaction.dart';

class HomeLineChart extends StatefulWidget {
  const HomeLineChart({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomeLineChartState();
}

class HomeLineChartState extends State<HomeLineChart> {
  final Color barBackgroundColor = const Color(0xff72d8bf);
  final Duration animDuration = const Duration(milliseconds: 250);
  late double _sumMo, _sumTu, _sumWe, _sumTh, _sumFr, _sumSa, _sumSu;

  int touchedIndex = -1;

  @override
  void initState() {
    getTransData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AspectRatio(
        aspectRatio: 1,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          color: const Color(0xff81e5cd),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    const Text(
                      'Weekly',
                      style: TextStyle(
                          color: Color(0xff0f4a3c),
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    const Text(
                      'Daily Total Expenses (RM)',
                      style: TextStyle(
                          color: Color(0xff379982),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 38,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: BarChart(
                          mainBarData(),
                          swapAnimationDuration: animDuration,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = const Color.fromARGB(255, 241, 137, 129),
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? Colors.yellow : barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: Colors.yellow, width: 1)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color: barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, _sumMo, isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, _sumTu, isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, _sumWe, isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, _sumTh, isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, _sumFr, isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, _sumSa, isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, _sumSu, isTouched: i == touchedIndex);
          default:
            return throw Error();
        }
      });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = 'Monday';
                  break;
                case 1:
                  weekDay = 'Tuesday';
                  break;
                case 2:
                  weekDay = 'Wednesday';
                  break;
                case 3:
                  weekDay = 'Thursday';
                  break;
                case 4:
                  weekDay = 'Friday';
                  break;
                case 5:
                  weekDay = 'Saturday';
                  break;
                case 6:
                  weekDay = 'Sunday';
                  break;
                default:
                  throw Error();
              }
              return BarTooltipItem(
                weekDay + '\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: (rod.toY - 1).toString(),
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('M', style: style);
        break;
      case 1:
        text = const Text('T', style: style);
        break;
      case 2:
        text = const Text('W', style: style);
        break;
      case 3:
        text = const Text('T', style: style);
        break;
      case 4:
        text = const Text('F', style: style);
        break;
      case 5:
        text = const Text('S', style: style);
        break;
      case 6:
        text = const Text('S', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  void getTransData() {
    final transactions = Hive.box<Transaction>('transaction')
        .values
        .toList()
        .cast<Transaction>();

    if (transactions.isEmpty) {
      //Do empty stuff
      setState(() {
        _sumMo = 0;
        _sumTu = 0;
        _sumWe = 0;
        _sumTh = 0;
        _sumFr = 0;
        _sumSa = 0;
        _sumSu = 0;
      });
    } else {
      double sumMo = 0,
          sumTu = 0,
          sumWe = 0,
          sumTh = 0,
          sumFr = 0,
          sumSa = 0,
          sumSu = 0;

      for (var i = 0; i < transactions.length; i++) {
        var monday = 1;
        var now = DateTime.now();

        while (now.weekday != monday) {
          now = now.subtract(const Duration(days: 1));
        }

        if (now.isSameDate(transactions[i].createdDate)) {
          sumMo = sumMo + transactions[i].amount;
        } else if (now
            .add(Duration(days: 1))
            .isSameDate(transactions[i].createdDate)) {
          sumTu = sumTu + transactions[i].amount;
        } else if (now
            .add(Duration(days: 2))
            .isSameDate(transactions[i].createdDate)) {
          sumWe = sumWe + transactions[i].amount;
        } else if (now
            .add(Duration(days: 3))
            .isSameDate(transactions[i].createdDate)) {
          sumTh = sumTh + transactions[i].amount;
        } else if (now
            .add(Duration(days: 4))
            .isSameDate(transactions[i].createdDate)) {
          sumFr = sumFr + transactions[i].amount;
        } else if (now
            .add(Duration(days: 5))
            .isSameDate(transactions[i].createdDate)) {
          sumSa = sumSa + transactions[i].amount;
        } else if (now
            .add(Duration(days: 6))
            .isSameDate(transactions[i].createdDate)) {
          sumSu = sumSu + transactions[i].amount;
        }
      }

      setState(() {
        _sumMo = sumMo;
        _sumTu = sumTu;
        _sumWe = sumWe;
        _sumTh = sumTh;
        _sumFr = sumFr;
        _sumSa = sumSa;
        _sumSu = sumSu;
      });
    }
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
