// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../class/utils.dart';

class ChartPage extends StatefulWidget {
  double satis;
  String name;
  List<ChartData> list;
  ChartPage({
    Key? key,
    required this.satis,
    required this.name,
    required this.list,
  }) : super(key: key);

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {

  @override
  void initState() {
    super.initState();
    chartDolar.add(ChartData("${DateTime.now().day} ${months[DateTime.now().month - 1]} ${DateTime.now().year % 2000}", widget.satis));
  }
  
  @override
  void dispose() {
    super.dispose();
    chartDolar.removeLast();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.name} Grafik"),
      ),
      body: Center(
        child: Container(
          child: SfCartesianChart(
            // legend: Legend(isVisible: true),
            // isTransposed: true,
            primaryXAxis: CategoryAxis(
              labelRotation: 90,
            ),
            series: <ChartSeries>[
              SplineSeries<ChartData, String>(
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                ),
                dataSource: widget.list,
                xValueMapper: (ChartData data, _) => data.date,
                yValueMapper: (ChartData data, _) => data.oran
              )
            ],
          ),
        ),
      ),
    );
  }
}