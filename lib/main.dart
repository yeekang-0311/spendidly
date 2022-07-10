import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:spendidly/model/transaction.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:spendidly/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spendidly/pages/addTransaction_page.dart';
import 'package:spendidly/pages/lockScreen_page.dart';
import 'package:spendidly/pages/settings_page.dart';
import 'package:spendidly/services/notification_service.dart';

import 'pages/transactionList_page.dart';

CameraDescription? camera;
void main() async {
  // initialize Hive DB
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionAdapter());
  await Hive.openBox<Transaction>('transaction');
  await Hive.openBox("settings");

  var boxSettings = Hive.box("settings");

  // Initial default box
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

  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  tz.initializeTimeZones();

  //Obtain list of available cameras
  final cameras = await availableCameras();
  //Get specific camera
  camera = cameras.first;

  runApp(MaterialApp(
    title: 'Flutter Demo',
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
