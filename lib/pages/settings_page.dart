import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:spendidly/pages/retypePasscode_page.dart';
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
    bool isEmptyBox = boxSettings.isEmpty;
    if (isEmptyBox) {
      // Fill in the default values
      boxSettings.putAll({"passcodeEnmabled": "true", "passcode": "12345"});
    }
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
                  title: Text("Passcode"),
                  dense: true,
                  tileColor: ColorTheme.lightgray,
                ),
                ListTile(
                  leading: Icon(Icons.lock),
                  title: Text('Passcode'),
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
                  title: Text("Notifications"),
                  dense: true,
                  tileColor: ColorTheme.lightgray,
                ),
                ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text('Notification'),
                  onTap: () {},
                ),
              ],
            );
          },
        ));
  }
}
