import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:spendidly/model/transaction.dart';
import 'package:spendidly/pages/about.dart';
import 'package:spendidly/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spendidly/pages/addTransaction_page.dart';
import 'package:spendidly/pages/lockScreen_page.dart';
import 'package:spendidly/pages/settings_page.dart';

import 'pages/transactionList_page.dart';

CameraDescription? camera;
void main() async {
  // initialize Hive DB
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionAdapter());
  await Hive.openBox<Transaction>('transaction');
  await Hive.openBox("settings");

  var boxSettings = Hive.box("settings");

  WidgetsFlutterBinding.ensureInitialized();
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
        ? LockScreenPage()
        : HomePage(),
    routes: {
      '/settings/': (context) => const SettingsPage(),
      '/home/': (context) => const HomePage(),
      '/addTransaction/': (context) => const AddTransactionPage(),
      '/transactionList/': (context) => const TransactionListPage(),
    },
  ));
}
