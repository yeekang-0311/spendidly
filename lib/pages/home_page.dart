import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:spendidly/pages/home_line_chart.dart';
import 'package:spendidly/pages/home_pie_chart.dart';
import 'package:spendidly/pages/transactionList_page.dart';

import '../model/recurrent_transaction.dart';
import '../model/transaction.dart';
import '../widget/shared_navigation_drawer.dart';
import '../widget/shared_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool isLoading = true;
  final pages = [
    SingleChildScrollView(
      child: Column(
        children: const [
          HomeLineChart(),
          HomePieChart(),
        ],
      ),
    ),
    const TransactionListPage(),
  ];

  final titles = [
    'Home Page',
    'Transaction Page',
  ];

  @override
  void initState() {
    super.initState();
    checkAndupdateRecurrentTask();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedAppBar(
        title: titles[_selectedIndex],
        isBackButton: false,
        isSettings: true,
      ),
      drawer: const SharedNavigationDrawer(),
      body: isLoading
          ? const Center(
              child: SpinKitCircle(
                color: Colors.blueAccent,
                size: 150,
                duration: const Duration(seconds: 2),
              ),
            )
          : pages[_selectedIndex],
      bottomNavigationBar: CupertinoTabBar(
        activeColor: Colors.white,
        inactiveColor: Colors.white70,
        backgroundColor: const Color.fromRGBO(67, 88, 110, 43),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 22,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_balance_wallet_rounded,
              size: 22,
            ),
            label: "Transaction",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

void checkAndupdateRecurrentTask() {
  var box = Hive.box<RecurrentTransaction>('recurrent_transaction');
  final transactions = box.values.toList();

  for (var currentTran in transactions) {
    String period = currentTran.frequency;
    switch (period) {
      case "Daily":
        while (true) {
          if (currentTran.lastUpdate.isAfterDate(DateTime.now())) {
            break;
          } else {
            DateTime tempDateTime = DateTime(currentTran.lastUpdate.year,
                currentTran.lastUpdate.month, currentTran.lastUpdate.day + 1);
            addTransaction(currentTran.name, currentTran.amount,
                currentTran.category, currentTran.note, tempDateTime);
            currentTran.lastUpdate = tempDateTime;
            currentTran.save();
          }
        }
        break;
      case "Weekly":
        // If it is after 7 days then run again
        while (true) {
          if (currentTran.lastUpdate.isAfterDate(DateTime.now())) {
            break;
          } else {
            DateTime tempDateTime = DateTime(currentTran.lastUpdate.year,
                currentTran.lastUpdate.month, currentTran.lastUpdate.day + 7);
            addTransaction(currentTran.name, currentTran.amount,
                currentTran.category, currentTran.note, tempDateTime);
            currentTran.lastUpdate = tempDateTime;
            currentTran.save();
          }
        }
        break;
      case "Monthly":
        // If it is not the same month then run again
        while (true) {
          if (currentTran.lastUpdate.isAfterDate(DateTime.now())) {
            break;
          } else {
            DateTime tempDateTime = DateTime(currentTran.lastUpdate.year,
                currentTran.lastUpdate.month + 1, currentTran.lastUpdate.day);
            addTransaction(currentTran.name, currentTran.amount,
                currentTran.category, currentTran.note, tempDateTime);
            currentTran.lastUpdate = tempDateTime;
            currentTran.save();
          }
        }
        break;
    }
  }
}

Future addTransaction(
  String name,
  double amount,
  String category,
  String note,
  DateTime date,
) async {
  final transaction = Transaction()
    ..name = name
    ..createdDate = date
    ..amount = amount
    ..category = category
    ..note = note;

  Hive.box<Transaction>('transaction').add(transaction);
}

extension DateOnlyCompare on DateTime {
  bool isAfterDate(DateTime other) {
    if (year > other.year) {
      return true;
    } else if (year == other.year) {
      if (month > other.month) {
        return true;
      } else if (month == other.month) {
        if (day > other.day) {
          return true;
        } else if (day == other.day) {
          return true;
        }
      }
    }
    return false;
  }
}
