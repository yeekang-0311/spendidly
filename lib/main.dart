import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:spendidly/model/transaction.dart';
import 'package:spendidly/pages/about.dart';
import 'package:spendidly/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spendidly/pages/addTransaction_page.dart';

import 'pages/transactionList_page.dart';

CameraDescription? camera;
void main() async {
  // initialize Hive DB
  await Hive.initFlutter();

  WidgetsFlutterBinding.ensureInitialized();
  //Obtain list of available cameras
  final cameras = await availableCameras();
  //Get specific camera
  camera = cameras.first;

  Hive.registerAdapter(TransactionAdapter());
  await Hive.openBox<Transaction>('transaction');

  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
    routes: {
      '/login/': (context) => const AboutView(),
      '/home/': (context) => const HomePage(),
      '/addTransaction/': (context) => const AddTransactionPage(),
      '/transactionList/': (context) => const TransactionListPage(),
    },
  ));
}
