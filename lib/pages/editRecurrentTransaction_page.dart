import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:spendidly/model/recurrent_transaction.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../widget/shared_app_bar.dart';

class EditRecurrentTransactionPage extends StatefulWidget {
  final RecurrentTransaction trans;
  const EditRecurrentTransactionPage({Key? key, required this.trans})
      : super(key: key);

  @override
  State<EditRecurrentTransactionPage> createState() =>
      _EditRecurrentTransactionPageState();
}

class _EditRecurrentTransactionPageState
    extends State<EditRecurrentTransactionPage> {
  late final TextEditingController _name;
  late final TextEditingController _amount;
  late final TextEditingController _note;
  late String _category;
  late String _frequency;

  @override
  void initState() {
    _frequency = widget.trans.frequency;
    _name = TextEditingController(text: widget.trans.name);
    _amount = TextEditingController(text: widget.trans.amount.toString());
    _category = widget.trans.category;
    _note = TextEditingController(text: widget.trans.note);
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
        title: 'Edit Recurrent Transaction',
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
                    Text(":"),
                    SizedBox(
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
                    Text(":"),
                    SizedBox(
                      width: 9,
                    ),
                    SizedBox(
                      width: 245,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: TextField(
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
                    Text(":"),
                    SizedBox(
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
                    Text(":"),
                    SizedBox(
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
                    Text(":"),
                    SizedBox(
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
                          _amount.text = '0';
                        }
                        addTransaction(_name.text, double.parse(_amount.text),
                            _category, _note.text, DateTime.now(), _frequency);
                      },
                      child: const Text('Save'),
                    ),
                    SizedBox(
                      width: 15,
                    ),
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
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    )
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
    widget.trans.name = name;
    widget.trans.lastUpdate = lastUpdate;
    widget.trans.amount = amount;
    widget.trans.category = category;
    widget.trans.note = note;
    widget.trans.frequency = freq;

    widget.trans.save();
    Navigator.of(context).pop();
  }
}
