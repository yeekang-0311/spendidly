import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spendidly/widget/color_theme.dart';
import 'package:spendidly/widget/shared_app_bar.dart';

class EditBudgetPage extends StatefulWidget {
  const EditBudgetPage({Key? key}) : super(key: key);

  @override
  State<EditBudgetPage> createState() => _EditBudgetPageState();
}

class _EditBudgetPageState extends State<EditBudgetPage> {
  late final TextEditingController _overallBudget;
  late final TextEditingController _generalBudget;
  late final TextEditingController _foodBudget;
  late final TextEditingController _sportsBudget;
  late final TextEditingController _transportationBudget;
  late final TextEditingController _entertainmentBudget;
  final boxBudget = Hive.box("budget");
  late bool enabledOverall;

  @override
  void initState() {
    enabledOverall = boxBudget.get("isOverallBudget") == true;
    _overallBudget = TextEditingController();
    _generalBudget = TextEditingController();
    _foodBudget = TextEditingController();
    _sportsBudget = TextEditingController();
    _transportationBudget = TextEditingController();
    _entertainmentBudget = TextEditingController();

    _generalBudget.text = boxBudget.get("generalBudget").toString();
    _overallBudget.text = boxBudget.get("overallBudget").toString();
    _foodBudget.text = boxBudget.get("foodBudget").toString();
    _transportationBudget.text =
        boxBudget.get("transportationBudget").toString();
    _sportsBudget.text = boxBudget.get("sportsBudget").toString();
    _entertainmentBudget.text = boxBudget.get("entertainmentBudget").toString();

    super.initState();
  }

  @override
  void dispose() {
    _overallBudget.dispose();
    _generalBudget.dispose();
    _foodBudget.dispose();
    _sportsBudget.dispose();
    _transportationBudget.dispose();
    _entertainmentBudget.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SharedAppBar(
        isBackButton: true,
        title: "Edit Budget",
        isSettings: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              ListTile(
                title: const Text("Overall Budget"),
                dense: true,
                tileColor: ColorTheme.white,
                trailing: Switch(
                  value: enabledOverall,
                  onChanged: (value) => {
                    setState(() {
                      enabledOverall = value;
                    })
                  },
                ),
              ),
              enabledOverall
                  ? Container(
                      decoration: const BoxDecoration(
                          color: Colors.white70,
                          border: Border(
                              bottom:
                                  BorderSide(width: 1, color: Colors.grey))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 15),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(
                                width: 150,
                                child: Text(
                                  "Overall Budget: ",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                height: 40,
                                child: TextField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(
                                        RegExp('[, -]'))
                                  ],
                                  textAlignVertical: TextAlignVertical.center,
                                  textAlign: TextAlign.center,
                                  controller: _overallBudget,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(height: 0.8),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              )
                            ]),
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                title: const Text("Category Budget"),
                dense: true,
                tileColor: ColorTheme.white,
                onTap: () {},
                trailing: Switch(
                  value: !enabledOverall,
                  onChanged: (value) => {
                    setState(() {
                      enabledOverall = !value;
                    })
                  },
                ),
              ),
              !enabledOverall
                  ? Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.white70,
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: Colors.grey))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 15),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(
                                    width: 150,
                                    child: Text(
                                      "General: ",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    height: 40,
                                    child: TextField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.deny(
                                            RegExp('[, -]'))
                                      ],
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      textAlign: TextAlign.center,
                                      controller: _generalBudget,
                                      keyboardType: TextInputType.number,
                                      style: const TextStyle(height: 0.8),
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  )
                                ]),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.white70,
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: Colors.grey))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 15),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(
                                    width: 150,
                                    child: Text(
                                      "Food: ",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    height: 40,
                                    child: TextField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.deny(
                                            RegExp('[, -]'))
                                      ],
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      textAlign: TextAlign.center,
                                      controller: _foodBudget,
                                      keyboardType: TextInputType.number,
                                      style: const TextStyle(height: 0.8),
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  )
                                ]),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.white70,
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: Colors.grey))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 15),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(
                                    width: 150,
                                    child: Text(
                                      "Sports: ",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    height: 40,
                                    child: TextField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.deny(
                                            RegExp('[, -]'))
                                      ],
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      textAlign: TextAlign.center,
                                      controller: _sportsBudget,
                                      keyboardType: TextInputType.number,
                                      style: const TextStyle(height: 0.8),
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  )
                                ]),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.white70,
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: Colors.grey))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 15),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(
                                    width: 150,
                                    child: Text(
                                      "Transportation: ",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    height: 40,
                                    child: TextField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.deny(
                                            RegExp('[, -]'))
                                      ],
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      textAlign: TextAlign.center,
                                      controller: _transportationBudget,
                                      keyboardType: TextInputType.number,
                                      style: const TextStyle(height: 0.8),
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  )
                                ]),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.white70,
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: Colors.grey))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(
                                  width: 150,
                                  child: Text(
                                    "Entertainment: ",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                SizedBox(
                                  width: 100,
                                  height: 40,
                                  child: TextField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(
                                          RegExp('[, -]'))
                                    ],
                                    textAlignVertical: TextAlignVertical.center,
                                    textAlign: TextAlign.center,
                                    controller: _entertainmentBudget,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(height: 0.8),
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(90, 8)),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
                  backgroundColor: MaterialStateProperty.all(Colors.amber),
                ),
                onPressed: () {
                  if (enabledOverall) {
                    if (_overallBudget.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Overall budget is empty"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      _generalBudget.text = "0";
                      _foodBudget.text = "0";
                      _transportationBudget.text = "0";
                      _sportsBudget.text = "0";
                      _entertainmentBudget.text = "0";
                      update();
                    }
                  } else if (_generalBudget.text.isEmpty |
                      _foodBudget.text.isEmpty |
                      _sportsBudget.text.isEmpty |
                      _transportationBudget.text.isEmpty |
                      _entertainmentBudget.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Amount should not be empty"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    _overallBudget.text = "0";
                    update();
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void update() async {
    await boxBudget.putAll({
      "isOverallBudget": enabledOverall,
      "generalBudget": _generalBudget.text,
      "foodBudget": _foodBudget.text,
      "sportsBudget": _sportsBudget.text,
      "transportationBudget": _transportationBudget.text,
      "entertainmentBudget": _entertainmentBudget.text,
      "overallBudget": _overallBudget.text,
    });
    Navigator.of(context).pop();
  }
}
