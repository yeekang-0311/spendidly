import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:spendidly/model/transaction.dart';

import '../widget/shared_app_bar.dart';

class EditTransactionPage extends StatefulWidget {
  final Transaction trans;
  const EditTransactionPage({
    Key? key,
    required this.trans,
  }) : super(key: key);

  @override
  State<EditTransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<EditTransactionPage> {
  late final TextEditingController _name;
  late final TextEditingController _amount;
  late final TextEditingController _note;
  late String _category;
  late DateTime _date;

  @override
  void initState() {
    _name = TextEditingController(text: widget.trans.name);
    _amount = TextEditingController(text: widget.trans.amount.toString());
    _category = widget.trans.category;
    _date = widget.trans.createdDate;
    _note = TextEditingController(text: widget.trans.note);
    super.initState();
  }

  @override
  void dispose() {
    // Hive.box('transaction').close();
    _name.dispose();
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SharedAppBar(
        title: 'Edit Transaction',
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
                        "Date",
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
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: const Color.fromARGB(255, 121, 121, 121),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 27, horizontal: 5)),
                              Text(
                                _date.toString().substring(0, 10),
                                style: const TextStyle(fontSize: 17),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    DateTime? newDate = await showDatePicker(
                                      context: context,
                                      initialDate: _date,
                                      lastDate: DateTime(2100),
                                      firstDate: DateTime(2000),
                                    );

                                    if (newDate == null) return;

                                    setState(() {
                                      _date = newDate;
                                    });
                                  },
                                  icon: const Icon(Icons.calendar_month))
                            ],
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
                          updateTransaction(widget.trans);
                        }
                      },
                      child: const Text('Save'),
                    ),
                    const SizedBox(
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

  void updateTransaction(Transaction trans) async {
    trans.name = _name.text;
    trans.amount = double.parse(_amount.text);
    trans.category = _category;
    trans.createdDate = _date;
    trans.note = _note.text;

    await trans.save();
    Navigator.of(context).pop();
  }
}
