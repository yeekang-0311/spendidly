import 'package:flutter/material.dart';
import 'package:spendidly/pages/scanner_page.dart';
import 'package:spendidly/pages/settings_page.dart';

class SharedNavigationDrawer extends StatelessWidget {
  const SharedNavigationDrawer({Key? key}) : super(key: key);
  final padding = const EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: const Color.fromRGBO(67, 88, 110, 43),
        child: ListView(
          padding: padding,
          children: <Widget>[
            const SizedBox(
              height: 30,
            ),
            ListTile(
              leading: const Icon(Icons.people, color: Colors.white),
              title: const Text(
                'People',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {},
              hoverColor: Colors.white70,
            ),
            const SizedBox(height: 10),
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
            const SizedBox(height: 10),
            const Divider(color: Colors.white),
            const SizedBox(height: 10),
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
