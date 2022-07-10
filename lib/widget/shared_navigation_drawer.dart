import 'package:flutter/material.dart';
import 'package:spendidly/model/recurrent_transaction.dart';
import 'package:spendidly/pages/recurrentTransactionList_page.dart';
import 'package:spendidly/pages/scanner_page.dart';
import 'package:spendidly/pages/settings_page.dart';
import 'package:spendidly/widget/color_theme.dart';

class SharedNavigationDrawer extends StatelessWidget {
  const SharedNavigationDrawer({Key? key}) : super(key: key);
  final padding = const EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: const Color.fromRGBO(67, 88, 110, 43),
        child: ListView(
          children: <Widget>[
            ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              tileColor: ColorTheme.gray,
              textColor: Colors.white,
              leading: const ImageIcon(
                AssetImage("assets/icons/ic_stat_monetization_on.png"),
                color: Colors.white,
                size: 40,
              ),
              subtitle: const Text(
                "Manage your expense with ease",
                style: TextStyle(fontSize: 12),
              ),
              title: const Text(
                'Spendidly',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              hoverColor: Colors.white70,
            ),
            const Divider(
              color: Colors.white,
              height: 0,
            ),
            ListTile(
              leading: const Icon(Icons.loop, color: Colors.white),
              title: const Text(
                'Recurrent Transaction',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        const RecurrentTransactionListPage()));
              },
              hoverColor: Colors.white70,
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.white),
              title: const Text(
                'Scanner',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ScannerPage(),
                ));
              },
              hoverColor: Colors.white70,
            ),
            const Divider(
              color: Colors.white,
              height: 0,
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text(
                'Settings',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ));
              },
              hoverColor: Colors.white70,
            )
          ],
        ),
      ),
    );
  }
}
