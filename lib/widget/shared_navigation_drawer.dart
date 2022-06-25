import 'package:flutter/material.dart';
import 'package:spendidly/pages/camera_page.dart';

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
              leading: const Icon(Icons.camera, color: Colors.white),
              title: const Text(
                'Camera',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CameraPage(),
                ));
              },
              hoverColor: Colors.white70,
            ),
            const SizedBox(height: 10),
            const Divider(color: Colors.white),
            const SizedBox(height: 10),
            buildMenuItem(text: 'Settings', icon: Icons.settings),
          ],
        ),
      ),
    );
  }
}

Widget buildMenuItem({
  required String text,
  required IconData icon,
}) {
  const color = Colors.white;
  const hoverColor = Colors.white70;

  return ListTile(
    leading: Icon(icon, color: color),
    title: Text(
      text,
      style: const TextStyle(color: color),
    ),
    onTap: () {},
    hoverColor: hoverColor,
  );
}
