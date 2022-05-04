import 'package:flutter/material.dart';
import 'package:spendidly/pages/about.dart';
import 'package:spendidly/pages/home.dart';
import 'dart:developer' as devtools show log;

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const Home(),
    routes: {
      '/login/': (context) => const AboutView(),
      '/register/': (context) => const Home(),
    },
  ));
}
