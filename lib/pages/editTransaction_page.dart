import 'package:flutter/material.dart';
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
  late String _category;

  @override
  void initState() {
    _name = TextEditingController(text: widget.trans.name);
    _amount = TextEditingController(text: widget.trans.amount.toString());
    _category = widget.trans.category;
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
                    updateTransaction(widget.trans);
                  },
                  child: const Text('Save'),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(120, 12)),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(20)),
                    backgroundColor: MaterialStateProperty.all(Colors.amber),
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
      ),
    );
  }

  void updateTransaction(Transaction trans) {
    trans.name = _name.text;
    trans.amount = double.parse(_amount.text);
    trans.category = _category;

    trans.save();
    Navigator.of(context).pop();
  }
}
