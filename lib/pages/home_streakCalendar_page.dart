import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

import '../model/transaction.dart';

class HomeStreakCalendarPage extends StatefulWidget {
  const HomeStreakCalendarPage({Key? key}) : super(key: key);

  @override
  State<HomeStreakCalendarPage> createState() => _HomeStreakCalendarPageState();
}

class _HomeStreakCalendarPageState extends State<HomeStreakCalendarPage> {
  late CalendarFormat _calendarFormat = CalendarFormat.month;
  final boxTransaction = Hive.box<Transaction>('transaction');
  late int maxStreak = 0;
  late int currentStreak = 0;

  @override
  void initState() {
    generateDateList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                    width: 150,
                    height: 150,
                    child: Stack(children: [
                      const Positioned.fill(
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: SpinKitSpinningLines(
                              color: Color.fromARGB(100, 255, 82, 82),
                              lineWidth: 25,
                              size: 200.0,
                              duration: Duration(milliseconds: 2000),
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        left: 15,
                        bottom: 15,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Image.asset(
                            "assets/img/fire.png",
                            scale: 4.5,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        top: 50,
                        right: 5,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Center(
                            child: Text(
                              currentStreak.toString(),
                              style: const TextStyle(
                                  fontSize: 30,
                                  fontFamily: "Times new roman",
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ])),
                SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 150,
                  child: Column(
                    children: [
                      Card(
                        color: Colors.amber,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 11),
                          child: Column(children: [
                            Text(
                              EmojiParser().emojify(
                                  maxStreak.toString() + ":fire::fire:"),
                              style: const TextStyle(
                                  fontSize: 26, fontFamily: "Times new roman"),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              "HIGHEST STREAK",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ]),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Card(
                        color: Colors.lightGreen,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 11),
                          child: Column(
                            children: [
                              Text(
                                EmojiParser().emojify(
                                    currentStreak.toString() + ":fire:"),
                                style: const TextStyle(
                                    fontSize: 26,
                                    fontFamily: "Times new roman"),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "CURRENT STREAK",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: const BorderSide(color: Colors.grey, width: 1)),
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 15.0,
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: DateTime.now(),
                calendarFormat: _calendarFormat,
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                calendarStyle: const CalendarStyle(
                    outsideTextStyle:
                        TextStyle(color: Color.fromARGB(35, 0, 0, 0))),
                headerStyle: const HeaderStyle(
                    headerMargin: EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey, width: 1)))),
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, datetime, focusedDate) {
                    final transactions =
                        boxTransaction.values.toList().cast<Transaction>();
                    List<DateTime> allDateTime =
                        transactions.map((trans) => trans.createdDate).toList();

                    if (allDateTime.any((date) => date.isSameDate(datetime))) {
                      int consecutive = 0;
                      DateTime currentDT = datetime;
                      do {
                        consecutive++;
                        currentDT = currentDT.subtract(const Duration(days: 1));
                      } while (allDateTime
                          .any((date) => date.isSameDate(currentDT)));

                      return Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Stack(
                          children: [
                            Container(
                                height: double.infinity,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                    color: Colors.greenAccent),
                                child: Center(
                                    child: Text(datetime.day.toString()))),
                            Positioned(
                              top: -5,
                              left: -5,
                              child: Container(
                                width: 35,
                                decoration: const BoxDecoration(
                                    color: Colors.amberAccent),
                                child: Padding(
                                  padding: const EdgeInsets.all(1.5),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      EmojiParser().emojify(
                                          consecutive.toString() + ":fire:"),
                                      // "2123123131123",
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                          clipBehavior: Clip.none,
                        ),
                      );
                    } else {
                      return null;
                    }
                  },
                  dowBuilder: (context, day) {
                    return Center(
                      child: Text(
                        DateFormat.E().format(day),
                        style: const TextStyle(color: Colors.lightBlue),
                      ),
                    );
                  },
                ),
                availableGestures: AvailableGestures.horizontalSwipe,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void generateDateList() {
    final transactions = boxTransaction.values.toList().cast<Transaction>();
    int maxConsecutive = 0;
    int currentConsecutive = 0;
    List<DateConsecutive> tempDateList = [];
    // Sort the transaction
    transactions.sort((a, b) => a.createdDate.compareTo(b.createdDate));
    int consecutive = 0;
    for (int i = 0; i < transactions.length; i++) {
      if (i == 0) {
        consecutive++;
      } else if (transactions[i - 1]
          .createdDate
          .isSameDate(transactions[i].createdDate)) {
      } else if (transactions[i - 1]
          .createdDate
          .add(const Duration(days: 1))
          .isSameDate(transactions[i].createdDate)) {
        consecutive++;
      } else {
        consecutive = 1;
      }
      tempDateList
          .add(DateConsecutive(transactions[i].createdDate, consecutive));

      // Get max consecutive streak
      if (consecutive > maxConsecutive) {
        maxConsecutive = consecutive;
      }
      if (tempDateList.isNotEmpty) {
        // Get current consecutive streak
        for (int i = tempDateList.length - 1; i > 0; i--) {
          if (tempDateList[i]
              .date
              .isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
            currentConsecutive = tempDateList[i].consecutive;
            break;
          }
        }
      }
    }
    setState(() {
      maxStreak = maxConsecutive;
      currentStreak = currentConsecutive;
    });
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

class DateConsecutive {
  DateConsecutive(this.date, this.consecutive);

  late DateTime date;
  late int consecutive;
}
