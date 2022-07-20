import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:spendidly/pages/edit_budget_page.dart';
import 'package:spendidly/widget/shared_app_bar.dart';
import 'package:pie_chart/pie_chart.dart';

import '../model/transaction.dart';

class BudgetPlannerPage extends StatefulWidget {
  const BudgetPlannerPage({Key? key}) : super(key: key);

  @override
  State<BudgetPlannerPage> createState() => _BudgetPlannerPageState();
}

class _BudgetPlannerPageState extends State<BudgetPlannerPage> {
  final boxTransaction = Hive.box<Transaction>("transaction");
  final colorList = [
    const Color.fromARGB(255, 117, 245, 122),
    const Color.fromARGB(255, 253, 69, 56)
  ];
  final cardColorList = [
    Colors.green.shade900,
    Colors.cyan.shade900,
    Colors.indigo.shade900,
    Colors.purple.shade900,
    Colors.deepPurple.shade900,
    Colors.blueGrey.shade900,
    Colors.brown.shade900
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SharedAppBar(
        isBackButton: true,
        title: "Budget Planner",
        isSettings: false,
      ),
      body: ValueListenableBuilder<Box>(
          valueListenable: Hive.box("budget").listenable(),
          builder: (context, box, _) {
            final bool enabledOverall = box.get("isOverallBudget");

            if (enabledOverall) {
              final double budget = double.parse(box.get("overallBudget"));
              List<Transaction> filteredTransaction = boxTransaction.values
                  .toList()
                  .cast<Transaction>()
                  .where((element) =>
                      element.createdDate.month == DateTime.now().month)
                  .toList();
              double sum = 0;
              for (var trans in filteredTransaction) {
                sum = sum + trans.amount;
              }
              final remaining = budget - sum;
              final Map<String, double> overallData = {
                "Remaining": remaining,
                "Spent": sum,
              };
              return SingleChildScrollView(
                child: Column(children: [
                  buildPieChart(overallData, budget, remaining, sum, "overall")
                ]),
              );
            } else {
              return SingleChildScrollView(
                child: Column(children: [
                  // Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: buildPieChart(overallData, budget, remaining, sum))
                  getDataAndBuildPieChart(box, 'general'),
                  getDataAndBuildPieChart(box, 'food'),
                  getDataAndBuildPieChart(box, 'sports'),
                  getDataAndBuildPieChart(box, 'transportation'),
                  getDataAndBuildPieChart(box, 'entertainment'),
                ]),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: () => {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) => const EditBudgetPage())))
              },
          tooltip: 'Add Transaction',
          child: const Icon(Icons.edit)),
    );
  }

  getDataAndBuildPieChart(Box box, String category) {
    final double budget = double.parse(box.get(category + "Budget"));
    List<Transaction> filteredTransaction = boxTransaction.values
        .toList()
        .cast<Transaction>()
        .where((element) =>
            (element.createdDate.month == DateTime.now().month) &&
            (element.category == category.capitalize()))
        .toList();
    double spent = 0;
    for (var trans in filteredTransaction) {
      spent = spent + trans.amount;
    }
    final remaining = budget - spent;
    final Map<String, double> data = {
      "Remaining": remaining,
      "Spent": spent,
    };
    return buildPieChart(data, budget, remaining, spent, category);
  }

  buildPieChart(data, budget, remaining, spent, String category) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        // color: const Color.fromARGB(170, 0, 27, 53),
        color: cardColorList.getRandomElement(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Column(
            children: [
              Text(
                category.capitalize() + " Budget",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: "Times new roman"),
              ),
              Text(
                budget != 0
                    ? NumberFormat('\$#,###.00').format(budget)
                    : NumberFormat('\$#,###').format(budget),
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: "Times new roman"),
              ),
              const SizedBox(
                height: 30,
              ),
              PieChart(
                chartRadius: 250,
                dataMap: data,
                legendOptions: const LegendOptions(
                  showLegends: false,
                ),
                colorList: colorList,
                chartValuesOptions: const ChartValuesOptions(
                  chartValueStyle: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                  showChartValueBackground: false,
                  showChartValues: true,
                  showChartValuesInPercentage: false,
                  showChartValuesOutside: false,
                  decimalPlaces: 2,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text(
                        "Remaining",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: "Times new roman"),
                      ),
                      Text(
                        NumberFormat('\$#,###.00').format(remaining),
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: colorList[0],
                            fontFamily: "Times new roman"),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        "Spent",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: "Times new roman"),
                      ),
                      Text(
                        NumberFormat('\$#,###.00').format(spent),
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: colorList[1],
                            fontFamily: "Times new roman"),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension ListExtension on List {
  T getRandomElement<T>() {
    final random = Random();
    var i = random.nextInt(length);
    return this[i];
  }
}
