import 'package:flutter/material.dart';
import 'package:spendidly/model/recurrent_transaction.dart';
import 'package:spendidly/model/transaction.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:spendidly/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spendidly/pages/addTransaction_page.dart';
import 'package:spendidly/pages/lockScreen_page.dart';
import 'package:spendidly/pages/settings_page.dart';
import 'package:spendidly/services/notification_service.dart';

import 'pages/transactionList_page.dart';

void main() async {
  // initialize Hive DB
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(RecurrentTransactionAdapter());

  await Hive.openBox<Transaction>('transaction');
  await Hive.openBox<RecurrentTransaction>('recurrent_transaction');
  await Hive.openBox("settings");

  var boxSettings = Hive.box("settings");

  // Initial default settings box
  bool isEmptyBox = boxSettings.isEmpty;
  if (isEmptyBox) {
    // Fill in the default values
    boxSettings.putAll({
      "passcodeEnabled": "false",
      "passcode": "",
      "notificationEnabled": "false",
      "notificationHour": 10,
      "notificationMinute": 15,
    });
  }

  // Meant for notifications
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  tz.initializeTimeZones();

  checkAndupdateRecurrentTask();

  runApp(MaterialApp(
    title: 'Spendidly',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    // home: const HomePage(),
    home: boxSettings.get("passcodeEnabled") == "true"
        ? const LockScreenPage()
        : const HomePage(),
    routes: {
      '/settings/': (context) => const SettingsPage(),
      '/home/': (context) => const HomePage(),
      '/addTransaction/': (context) => const AddTransactionPage(),
      '/transactionList/': (context) => const TransactionListPage(),
    },
  ));
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
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
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
          if (currentTran.lastUpdate.isSameDate(DateTime.now())) {
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
          if (currentTran.lastUpdate.isSameDate(DateTime.now())) {
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
          if (currentTran.lastUpdate.isSameDate(DateTime.now())) {
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
