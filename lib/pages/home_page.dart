import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spendidly/pages/transactionList_page.dart';
import 'package:spendidly/pages/addTransaction_page.dart';

import '../widget/shared_navigation_drawer.dart';
import '../widget/shared_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final pages = [
    Text("ASDASDASD"),
    TransactionListPage(),
  ];

  final titles = [
    'Home Page',
    'Transaction Page',
  ];

  @override
  void initState() {
    super.initState();
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
      appBar: SharedAppBar(title: titles[_selectedIndex], isBackButton: false),
      drawer: const SharedNavigationDrawer(),
      body: pages[_selectedIndex],
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
