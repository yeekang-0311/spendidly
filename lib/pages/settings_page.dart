import 'package:flutter/material.dart';
import 'package:spendidly/pages/retypePasscode_page.dart';
import 'package:spendidly/pages/setNotification_page.dart';
import 'package:spendidly/pages/setPasscode_page.dart';
import 'package:spendidly/widget/color_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../widget/shared_app_bar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final boxSettings = Hive.box("settings");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const SharedAppBar(
          title: "Settings",
          isBackButton: true,
          isSettings: false,
        ),
        body: ValueListenableBuilder<Box>(
          valueListenable: Hive.box('settings').listenable(),
          builder: (context, box, widget) {
            return ListView(
              children: <Widget>[
                ListTile(
                  title: const Text("Passcode"),
                  dense: true,
                  tileColor: ColorTheme.lightgray,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.lock,
                    size: 40,
                  ),
                  title: const Text('Passcode'),
                  subtitle: boxSettings.get("passcodeEnabled") == "true"
                      ? const Text(
                          "ON",
                          style: TextStyle(color: Colors.green),
                        )
                      : const Text(
                          "OFF",
                          style: TextStyle(color: Colors.red),
                        ),
                  onTap: () async {
                    if (boxSettings.get("passcodeEnabled") == "true") {
                      final bool result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RetypePasscodePage(
                                  title: "Security PIN",
                                  passcode: boxSettings.get("passcode"),
                                )),
                      );
                      if (result) {
                        boxSettings.put("passcodeEnabled", "false");
                      }
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SetPasscodePage()));
                    }
                  },
                  trailing: Switch(
                    value: boxSettings.get("passcodeEnabled") == "true",
                    onChanged: (void bool) {},
                  ),
                ),
                ListTile(
                  title: const Text("Notifications"),
                  dense: true,
                  tileColor: ColorTheme.lightgray,
                  enabled: false,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.notifications,
                    size: 40,
                  ),
                  title: const Text('Notification'),
                  subtitle: boxSettings.get("notificationEnabled") == "true"
                      ? const Text(
                          "ON",
                          style: TextStyle(color: Colors.green),
                        )
                      : const Text(
                          "OFF",
                          style: TextStyle(color: Colors.red),
                        ),
                  trailing: Switch(
                      value: boxSettings.get("notificationEnabled") == "true",
                      onChanged: (bool value) {}),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SetNotificationPage()));
                  },
                ),
                const Divider(
                  height: 0,
                  color: Colors.grey,
                )
              ],
            );
          },
        ));
  }
}
