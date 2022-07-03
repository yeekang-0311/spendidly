import 'package:flutter/material.dart';
import 'package:spendidly/model/transaction.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spendidly/pages/editTransaction_page.dart';

class TransactionListPage extends StatefulWidget {
  const TransactionListPage({Key? key}) : super(key: key);

  @override
  State<TransactionListPage> createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Hive.box('transaction').close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<Box<Transaction>>(
        valueListenable: Hive.box<Transaction>('transaction').listenable(),
        builder: (context, box, _) {
          final transaction = box.values.toList().cast<Transaction>();
          return buildContent(transaction);
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => {
                Navigator.of(context).pushNamed(
                  '/addTransaction/',
                )
              },
          tooltip: 'Add Transaction',
          child: const Icon(Icons.add)),
    );
  }
}

Widget buildContent(List<Transaction> transactions) {
  if (transactions.isEmpty) {
    return const Center(
      child: Text(
        'No expenses yet!',
        style: TextStyle(fontSize: 24),
      ),
    );
  } else {
    final netExpense = transactions.fold<double>(
      0,
      (previousValue, transaction) => previousValue + transaction.amount,
    );
    final newExpenseString = '\$${netExpense.toStringAsFixed(2)}';
    const color = Colors.red;

    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_circle_left),
              onPressed: () {},
            ),
            OutlinedButton(
              onPressed: () {},
              child: Text("MONTH"),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_circle_right),
              onPressed: () {},
            )
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Net Expense: $newExpenseString',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: color,
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: transactions.length,
            itemBuilder: (BuildContext context, int index) {
              final transaction = transactions[index];
              return buildTransaction(context, transaction);
            },
          ),
        ),
      ],
    );
  }
}

Widget buildTransaction(
  BuildContext context,
  Transaction transaction,
) {
  const color = Colors.red;
  final date = transaction.createdDate.toString();
  final category = transaction.category.toString();
  final amount = '\$' + transaction.amount.toStringAsFixed(2);

  return Card(
    color: Colors.white,
    child: ExpansionTile(
      leading: Container(
        width: 100,
        child: Text(category),
      ),
      tilePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      title: Text(
        transaction.name,
        maxLines: 2,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      subtitle: Text(date),
      trailing: Text(
        amount,
        style:
            TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      children: [
        buildButtons(context, transaction),
      ],
    ),
  );
}

Widget buildButtons(BuildContext context, Transaction transaction) => Row(
      children: [
        Expanded(
          child: TextButton.icon(
            label: Text('Edit'),
            icon: Icon(Icons.edit),
            onPressed: () => {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditTransactionPage(trans: transaction),
              ))
            },
          ),
        ),
        Expanded(
          child: TextButton.icon(
            label: Text('Delete'),
            icon: Icon(Icons.delete),
            onPressed: () => {deleteTransaction(transaction)},
          ),
        )
      ],
    );

void deleteTransaction(Transaction trans) {
  trans.delete();
}
