import 'package:flutter/material.dart';
import 'package:spendidly/pages/line_chart_visualization.dart';
import 'package:spendidly/pages/pie_chart_visualization.dart';
import 'package:spendidly/widget/shared_app_bar.dart';

class AnalyticVisualizationPage extends StatefulWidget {
  const AnalyticVisualizationPage({Key? key}) : super(key: key);

  @override
  State<AnalyticVisualizationPage> createState() =>
      _AnalyticVisualizationPageState();
}

class _AnalyticVisualizationPageState extends State<AnalyticVisualizationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const SharedAppBar(
          isBackButton: true,
          title: "Analytic & Visualization",
          isSettings: false,
        ),
        body: SingleChildScrollView(
          child: Column(children: const [
            LineChartVisualization(),
            PieChartVisualization(),
          ]),
        ));
  }
}
