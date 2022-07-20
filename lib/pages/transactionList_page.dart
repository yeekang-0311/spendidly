import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:spendidly/model/transaction.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spendidly/pages/editTransaction_page.dart';
import 'package:spendidly/widget/category_icons.dart';
import 'package:spendidly/widget/color_theme.dart';

class TransactionListPage extends StatefulWidget {
  const TransactionListPage({Key? key}) : super(key: key);

  @override
  State<TransactionListPage> createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  DateTime viewingMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.white,
      body: ValueListenableBuilder<Box<Transaction>>(
        valueListenable: Hive.box<Transaction>('transaction').listenable(),
        builder: (context, box, _) {
          final transaction = box.values.toList().cast<Transaction>();
          List<Transaction> filteredTransaction = transaction
              .where(
                  (element) => element.createdDate.month == viewingMonth.month)
              .toList();
          // Sort the transaction
          filteredTransaction
              .sort((a, b) => b.createdDate.compareTo(a.createdDate));
          return buildContent(filteredTransaction);
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

  Widget buildContent(List<Transaction> transactions) {
    if (transactions.isEmpty) {
      return Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(216, 226, 237, 0.93),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_circle_left),
                    iconSize: 30,
                    onPressed: () {
                      setState(() {
                        viewingMonth = DateTime(viewingMonth.year,
                            viewingMonth.month - 1, viewingMonth.day);
                      });
                    },
                  ),
                  Container(
                    width: 264,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 7),
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          color: const Color.fromARGB(255, 76, 187, 252)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        DateFormat.yMMMM().format(viewingMonth),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_circle_right),
                    iconSize: 30,
                    onPressed: () {
                      setState(() {
                        viewingMonth = DateTime(viewingMonth.year,
                            viewingMonth.month + 1, viewingMonth.day);
                      });
                    },
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 80,
          ),
          const Text(
            "No Expense Yet!!",
            style: TextStyle(fontSize: 34),
          ),
          const SizedBox(
            height: 40,
          ),
          const Icon(
            Icons.cancel,
            size: 150,
          )
        ],
      );
    } else {
      return Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(216, 226, 237, 0.93),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_circle_left),
                  iconSize: 30,
                  onPressed: () {
                    setState(() {
                      viewingMonth = DateTime(viewingMonth.year,
                          viewingMonth.month - 1, viewingMonth.day);
                    });
                  },
                ),
                Container(
                    width: 264,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 7),
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          color: const Color.fromARGB(255, 76, 187, 252)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                        child: Text(
                      DateFormat.yMMMM().format(viewingMonth),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ))),
                IconButton(
                  icon: const Icon(Icons.arrow_circle_right),
                  iconSize: 30,
                  onPressed: () {
                    setState(() {
                      viewingMonth = DateTime(viewingMonth.year,
                          viewingMonth.month + 1, viewingMonth.day);
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          const Divider(
            height: 0,
            color: Colors.grey,
          ),
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
    final date = transaction.createdDate.toString().substring(0, 10);
    final category = transaction.category.toString();
    final amount = '\$' + transaction.amount.toStringAsFixed(2);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: SizedBox(
            width: 40,
            height: 40,
            child: SvgPicture.asset(
              CatIcons.getIcon(category),
            ),
          ),
          tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          title: Text(
            transaction.name,
            maxLines: 2,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          subtitle: Text(date),
          trailing: SizedBox(
            width: 60,
            child: Text(
              amount,
              style: const TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          children: [
            const Divider(
              height: 0,
              color: Colors.black,
            ),
            buildButtons(context, transaction),
          ],
        ),
      ),
    );
  }

  Widget buildButtons(BuildContext context, Transaction transaction) => Row(
        children: [
          Expanded(
            child: TextButton.icon(
              label: const Text('Edit'),
              icon: const Icon(Icons.edit),
              onPressed: () => {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EditTransactionPage(trans: transaction),
                ))
              },
            ),
          ),
          Expanded(
            child: TextButton.icon(
              label: const Text('Delete'),
              icon: const Icon(Icons.delete),
              onPressed: () => {deleteTransaction(transaction)},
            ),
          )
        ],
      );

  void deleteTransaction(Transaction trans) async {
    await trans.delete();
  }
}
