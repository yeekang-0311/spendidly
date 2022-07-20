import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spendidly/pages/addRecurrentTransaction_page.dart';
import 'package:spendidly/widget/category_icons.dart';
import 'package:spendidly/widget/shared_app_bar.dart';

import '../model/recurrent_transaction.dart';
import '../widget/color_theme.dart';
import 'editRecurrentTransaction_page.dart';

class RecurrentTransactionListPage extends StatefulWidget {
  const RecurrentTransactionListPage({Key? key}) : super(key: key);

  @override
  State<RecurrentTransactionListPage> createState() =>
      _RecurrentTransactionListPageState();
}

class _RecurrentTransactionListPageState
    extends State<RecurrentTransactionListPage> {
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
      appBar: const SharedAppBar(
        isBackButton: true,
        title: "Recurrent Transactions",
        isSettings: false,
      ),
      body: ValueListenableBuilder<Box<RecurrentTransaction>>(
        valueListenable: Hive.box<RecurrentTransaction>('recurrent_transaction')
            .listenable(),
        builder: (context, box, _) {
          final transaction = box.values.toList().cast<RecurrentTransaction>();
          return buildContent(transaction);
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AddRecurrentTransactionPage()))
              },
          tooltip: 'Add Transaction',
          child: const Icon(Icons.add)),
    );
  }

  Widget buildContent(List<RecurrentTransaction> transactions) {
    if (transactions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          children: const [
            SizedBox(
              height: 80,
            ),
            Text(
              "No Recurrent Transaction Yet!!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 34),
            ),
            SizedBox(
              height: 40,
            ),
            Icon(
              Icons.cancel,
              size: 150,
            )
          ],
        ),
      );
    } else {
      return Column(
        children: [
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
    RecurrentTransaction transaction,
  ) {
    const color = Colors.red;
    final frequency = transaction.frequency.toString();
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
          subtitle: Text(frequency),
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

  Widget buildButtons(BuildContext context, RecurrentTransaction transaction) =>
      Row(
        children: [
          Expanded(
            child: TextButton.icon(
              label: const Text('Edit'),
              icon: const Icon(Icons.edit),
              onPressed: () => {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      EditRecurrentTransactionPage(trans: transaction),
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

  void deleteTransaction(RecurrentTransaction trans) async {
    await trans.delete();
  }
}
