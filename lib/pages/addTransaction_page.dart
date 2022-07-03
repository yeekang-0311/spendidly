import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:spendidly/model/transaction.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../widget/shared_app_bar.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({Key? key}) : super(key: key);

  @override
  State<AddTransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<AddTransactionPage> {
  late final TextEditingController _name;
  late final TextEditingController _amount;
  late String _category;
  DateTime date = DateTime.now();

  @override
  void initState() {
    _name = TextEditingController();
    _amount = TextEditingController();
    _category = 'General';
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
      appBar: const SharedAppBar(title: 'Add Transaction', isBackButton: true),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  fixedSize: Size(230, 50),
                ),
                onPressed: () async {
                  DateTime? newDate = await showDatePicker(
                    context: context,
                    initialDate: date,
                    lastDate: DateTime(2100),
                    firstDate: DateTime(2000),
                  );

                  if (newDate == null) return;

                  setState(() {
                    date = newDate;
                  });
                },
                child: Text(
                  "Date: " + date.toString().substring(0, 10),
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextField(
                controller: _name,
                decoration: const InputDecoration(
                  hintText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
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
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
            const Padding(padding: EdgeInsets.all(9)),
            Row(
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(120, 12)),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(20)),
                    backgroundColor: MaterialStateProperty.all(Colors.amber),
                  ),
                  onPressed: () {
                    addTransaction(
                        _name.text, double.parse(_amount.text), _category);
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future addTransaction(String name, double amount, String category) async {
    final transaction = Transaction()
      ..name = name
      ..createdDate = date
      ..amount = amount
      ..category = category;

    Hive.box<Transaction>('transaction').add(transaction);
    Navigator.of(context).pop();
  }
}
