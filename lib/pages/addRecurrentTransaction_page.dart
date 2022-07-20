import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spendidly/model/recurrent_transaction.dart';

import '../widget/shared_app_bar.dart';

class AddRecurrentTransactionPage extends StatefulWidget {
  const AddRecurrentTransactionPage({Key? key}) : super(key: key);

  @override
  State<AddRecurrentTransactionPage> createState() =>
      _AddRecurrentTransactionPageState();
}

class _AddRecurrentTransactionPageState
    extends State<AddRecurrentTransactionPage> {
  late final TextEditingController _name;
  late final TextEditingController _amount;
  late final TextEditingController _note;
  late String _category;
  late String _frequency;

  @override
  void initState() {
    _name = TextEditingController();
    _amount = TextEditingController();
    _note = TextEditingController();
    _frequency = "Daily";
    _category = "General";
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SharedAppBar(
        title: 'Add Recurrent Transaction',
        isBackButton: true,
        isSettings: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text(
                        "Name",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    const Text(":"),
                    const SizedBox(
                      width: 9,
                    ),
                    SizedBox(
                      width: 245,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: TextField(
                          controller: _name,
                          decoration: const InputDecoration(
                            hintText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text(
                        "Amount (RM)",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    const Text(":"),
                    const SizedBox(
                      width: 9,
                    ),
                    SizedBox(
                      width: 245,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp('[, -]'))
                          ],
                          controller: _amount,
                          decoration: const InputDecoration(
                            hintText: 'Amount',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text(
                        "Category",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    const Text(":"),
                    const SizedBox(
                      width: 9,
                    ),
                    SizedBox(
                      width: 245,
                      child: Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: DropdownButton<String>(
                          value: _category,
                          icon: const Icon(Icons.arrow_drop_down),
                          elevation: 16,
                          // style: const TextStyle(color: Colors.deepPurple),
                          isExpanded: true,
                          onChanged: (String? newValue) {
                            setState(() {
                              _category = newValue!;
                            });
                          },
                          items: <String>[
                            'General',
                            'Entertainment',
                            'Food',
                            'Transportation',
                            'Sports'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text(
                        "Notes",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    const Text(":"),
                    const SizedBox(
                      width: 9,
                    ),
                    SizedBox(
                      width: 245,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: TextField(
                          controller: _note,
                          decoration: const InputDecoration(
                            hintText: 'Notes',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text(
                        "Recurrent Frequency",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    const Text(":"),
                    const SizedBox(
                      width: 9,
                    ),
                    SizedBox(
                      width: 245,
                      child: Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: DropdownButton<String>(
                          value: _frequency,
                          icon: const Icon(Icons.arrow_drop_down),
                          elevation: 16,
                          // style: const TextStyle(color: Colors.deepPurple),
                          isExpanded: true,
                          onChanged: (String? newValue) {
                            setState(() {
                              _frequency = newValue!;
                            });
                          },
                          items: <String>[
                            'Daily',
                            'Weekly',
                            'Monthly',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.all(9)),
                Row(
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all(const Size(90, 8)),
                        padding:
                            MaterialStateProperty.all(const EdgeInsets.all(15)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.amber),
                      ),
                      onPressed: () {
                        if (_amount.text.isEmpty) {
                          // _amount.text = '0';
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Amount should not be empty"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else if (_name.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Name should not be empty"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          addTransaction(
                              _name.text,
                              double.parse(_amount.text),
                              _category,
                              _note.text,
                              DateTime.now(),
                              _frequency);
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future addTransaction(
    String name,
    double amount,
    String category,
    String note,
    DateTime lastUpdate,
    String freq,
  ) async {
    final recurrentTransaction = RecurrentTransaction()
      ..name = name
      ..lastUpdate = lastUpdate
      ..amount = amount
      ..category = category
      ..note = note
      ..frequency = freq;

    await Hive.box<RecurrentTransaction>('recurrent_transaction')
        .add(recurrentTransaction);
    Navigator.of(context).pop();
  }
}
