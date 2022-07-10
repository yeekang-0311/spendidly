import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:spendidly/services/notification_service.dart';
import 'package:spendidly/widget/color_theme.dart';
import 'package:spendidly/widget/shared_app_bar.dart';

class SetNotificationPage extends StatefulWidget {
  const SetNotificationPage({Key? key}) : super(key: key);

  @override
  State<SetNotificationPage> createState() => _SetNotificationPageState();
}

class _SetNotificationPageState extends State<SetNotificationPage> {
  final boxSettings = Hive.box("settings");
  late TimeOfDay time;
  late bool notificationEnabled;

  @override
  void initState() {
    int hour = boxSettings.get("notificationHour");
    int minutes = boxSettings.get("notificationMinute");
    time = TimeOfDay(hour: hour, minute: minutes);
    notificationEnabled = boxSettings.get("notificationEnabled") == "true";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');

    return Scaffold(
      appBar: const SharedAppBar(
          title: "Notification", isBackButton: true, isSettings: false),
      body: Column(children: [
        const SizedBox(
          height: 10,
        ),
        ListTile(
          leading: const Icon(Icons.alarm, size: 60, color: Colors.amber),
          title: const Text("Notification"),
          subtitle: const Text("Notification will be set for daily reminder"),
          onTap: () {
            setState(() {
              notificationEnabled = !notificationEnabled;
            });
            if (notificationEnabled) {
              boxSettings.put("notificationEnabled", "true");
              DateTime today = DateTime.now();
              DateTime customDateTime = DateTime(
                  today.year, today.month, today.day, time.hour, time.minute);
              TimeOfDay setTime =
                  TimeOfDay.fromDateTime(customDateTime.toUtc());
              NotificationService().cancelAll;
              NotificationService().setNotification(
                  1,
                  "Reminder",
                  "Have you recorded your expenses today ?",
                  setTime.hour,
                  setTime.minute);
            } else {
              boxSettings.put("notificationEnabled", "false");
              NotificationService().cancelAll;
            }
          },
          trailing:
              Switch(value: notificationEnabled, onChanged: (bool value) {}),
        ),
        const SizedBox(
          height: 20,
        ),
        const Divider(
          color: Colors.grey,
          height: 0,
        ),
        notificationEnabled
            ? Container(
                decoration: BoxDecoration(color: ColorTheme.white),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9)),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                hours,
                                style: const TextStyle(fontSize: 60),
                              ),
                            ),
                          ),
                          const Text(
                            ":",
                            style: TextStyle(fontSize: 60),
                          ),
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9)),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                minutes,
                                style: const TextStyle(fontSize: 60),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          TimeOfDay? newtime = await showTimePicker(
                              context: context, initialTime: time);

                          if (newtime == null) {
                            return;
                          }
                          setState(() {
                            time = newtime;
                          });
                          boxSettings.put("notificationHour", time.hour);
                          boxSettings.put("notificationMinute", time.minute);

                          if (boxSettings.get("notificationEnabled") ==
                              "true") {
                            DateTime today = DateTime.now();
                            DateTime customDateTime = DateTime(today.year,
                                today.month, today.day, time.hour, time.minute);
                            TimeOfDay setTime =
                                TimeOfDay.fromDateTime(customDateTime.toUtc());
                            NotificationService().cancelAll;
                            NotificationService().setNotification(
                                1,
                                "Daily Reminder",
                                "Have you recorded your expenses today ?",
                                setTime.hour,
                                setTime.minute);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SizedBox(
                            width: 120,
                            child: Center(
                              child: Row(
                                children: const [
                                  Icon(Icons.access_time_filled),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Time Picker",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox(),
      ]),
    );
  }
}
