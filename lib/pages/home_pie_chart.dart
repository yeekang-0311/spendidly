import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:spendidly/widget/category_icons.dart';
import 'package:spendidly/widget/color_theme.dart';

import '../model/transaction.dart';

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
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: ColorTheme.lightblue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Column(
            children: [
              const SizedBox(
                height: 18,
              ),
              const Text(
                "Monthly Expenses",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Hive.box<Transaction>('transaction').isEmpty
                  ? Center(
                      child: Column(
                        children: const [
                          SizedBox(
                            height: 80,
                          ),
                          Text(
                            "No Expenses Yet !!",
                            style: TextStyle(fontSize: 25),
                          ),
                        ],
                      ),
                    )
                  : AspectRatio(
                      aspectRatio: 1.2,
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
                            centerSpaceRadius: 0,
                            sections: showingSections()),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(5, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 130.0 : 120.0;
      final widgetSize = isTouched ? 55.0 : 40.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: _sumGe,
            title: _sumGe.toStringAsFixed(0) + "%",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
            badgeWidget: _Badge(
              CatIcons.general,
              size: widgetSize,
              borderColor: const Color(0xff0293ee),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: _sumFo,
            title: _sumFo.toStringAsFixed(0) + "%",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
            badgeWidget: _Badge(
              CatIcons.food,
              size: widgetSize,
              borderColor: const Color(0xfff8b250),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: _sumEn,
            title: _sumEn.toStringAsFixed(0) + "%",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
            badgeWidget: _Badge(
              CatIcons.entertainment,
              size: widgetSize,
              borderColor: const Color(0xff845bef),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 3:
          return PieChartSectionData(
            color: const Color.fromARGB(255, 19, 173, 211),
            value: _sumTr,
            title: _sumTr.toStringAsFixed(0) + "%",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
            badgeWidget: _Badge(
              CatIcons.transportation,
              size: widgetSize,
              borderColor: const Color.fromARGB(255, 19, 173, 211),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 4:
          return PieChartSectionData(
            color: const Color.fromARGB(255, 211, 19, 93),
            value: _sumSp,
            title: _sumSp.toStringAsFixed(0) + "%",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
            badgeWidget: _Badge(
              CatIcons.sports,
              size: widgetSize,
              borderColor: const Color.fromARGB(255, 211, 19, 93),
            ),
            badgePositionPercentageOffset: .98,
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
      setState(() {
        _sumGe = 0;
        _sumFo = 0;
        _sumEn = 0;
        _sumSp = 0;
        _sumTr = 0;
      });
    } else {
      double sumGe = 0, sumTr = 0, sumFo = 0, sumEn = 0, sumSp = 0;

      for (var i = 0; i < transactions.length; i++) {
        if (transactions[i].createdDate.month == DateTime.now().month) {
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
      }
      double total = sumEn + sumSp + sumEn + sumGe + sumTr;
      setState(() {
        _sumGe = ((sumGe / total) * 100);
        _sumFo = ((sumFo / total) * 100);
        _sumEn = ((sumEn / total) * 100);
        _sumSp = ((sumSp / total) * 100);
        _sumTr = ((sumTr / total) * 100);
      });
    }
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color borderColor;

  const _Badge(
    this.icon, {
    Key? key,
    required this.size,
    required this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: Icon(icon),
      ),
    );
  }
}
