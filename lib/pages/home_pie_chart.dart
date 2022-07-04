import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

import '../model/transaction.dart';
import '../widget/indicator.dart';

class HomePieChart extends StatefulWidget {
  const HomePieChart({Key? key}) : super(key: key);

  @override
  State<HomePieChart> createState() => _HomePieChartState();
}

class _HomePieChartState extends State<HomePieChart> {
  int touchedIndex = -1;
  late double _sumGe, _sumEn, _sumTr, _sumFo, _sumSp;

  @override
  void initState() {
    getTransData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            const SizedBox(
              height: 18,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                      pieTouchData: PieTouchData(touchCallback:
                          (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      }),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      sections: showingSections()),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Indicator(
                  color: Color(0xff0293ee),
                  text: 'General',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Color(0xfff8b250),
                  text: 'Food',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Color(0xff845bef),
                  text: 'Entertainment',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Color.fromARGB(255, 19, 173, 211),
                  text: 'Transportation',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Color.fromARGB(255, 211, 19, 93),
                  text: 'Sports',
                  isSquare: true,
                ),
                SizedBox(
                  height: 18,
                ),
              ],
            ),
            const SizedBox(
              width: 28,
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: _sumGe,
            title: _sumGe.toString(),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: _sumFo,
            title: _sumFo.toString(),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: _sumEn,
            title: _sumEn.toString(),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: const Color.fromARGB(255, 19, 173, 211),
            value: _sumTr,
            title: _sumTr.toString(),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 4:
          return PieChartSectionData(
            color: Color.fromARGB(255, 211, 19, 93),
            value: _sumSp,
            title: _sumSp.toString(),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          throw Error();
      }
    });
  }

  void getTransData() {
    final transactions = Hive.box<Transaction>('transaction')
        .values
        .toList()
        .cast<Transaction>();

    if (transactions.isEmpty) {
      //Do empty stuff
    } else {
      double sumGe = 0, sumTr = 0, sumFo = 0, sumEn = 0, sumSp = 0;

      for (var i = 0; i < transactions.length; i++) {
        switch (transactions[i].category) {
          case 'General':
            {
              sumGe = sumGe + transactions[i].amount;
              break;
            }
          case 'Food':
            {
              sumFo = sumFo + transactions[i].amount;
              break;
            }
          case 'Transportation':
            {
              sumTr = sumTr + transactions[i].amount;
              break;
            }
          case 'Entertainment':
            {
              sumEn = sumEn + transactions[i].amount;
              break;
            }
          case 'Sports':
            {
              sumSp = sumSp + transactions[i].amount;
              break;
            }
          default:
            {
              break;
            }
        }
      }
      print(sumFo);

      setState(() {
        _sumGe = sumGe;
        _sumFo = sumFo;
        _sumEn = sumEn;
        _sumSp = sumSp;
        _sumTr = sumTr;
      });
    }
  }
}
