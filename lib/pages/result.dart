import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shababi_caffee/const.dart';
import 'package:shababi_caffee/services/apiService.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ResultPage extends StatefulWidget {
  static String id = "/Result";

  const ResultPage({Key? key}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  List<DataPoint> _dataPoints = [];
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _fetchData(); // Initial data fetch
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _fetchData(); // Fetch data every second
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel timer to prevent memory leaks
    super.dispose();
  }

  Future<void> _fetchData() async {
    var teams = await ApiService.getTeams();
    if (teams['status'] == "success") {
      teams = teams["teams"];
      setState(() {
        _dataPoints = teams.map<DataPoint>((team) {
          return DataPoint(
            team['name'],
            double.parse(team['points']),
            toColor(team['color']),
          );
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        centerTitle: true,
        title: const Text(
          "الـنـتـائـج",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: 0.4,
            image: AssetImage("assets/images/logo.png"),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: _dataPoints.isNotEmpty
                ? HistogramChart(
                    data: _dataPoints,
                  )
                : CircularProgressIndicator(
                    color: appColor,
                  ),
          ),
        ),
      ),
    );
  }
}

class DataPoint {
  final String x;
  final double y;
  final Color color;

  DataPoint(this.x, this.y, this.color);
}

class HistogramChart extends StatelessWidget {
  final List<DataPoint> data;

  const HistogramChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      _createSeries(),
      animate: true,
      vertical: true, // Set to true for vertical orientation
      domainAxis: const charts.OrdinalAxisSpec(
        showAxisLine: true,
        renderSpec: charts.SmallTickRendererSpec(labelRotation: 45),
      ),
    );
  }

  List<charts.Series<DataPoint, String>> _createSeries() {
    return [
      charts.Series<DataPoint, String>(
        id: 'Histogram',
        colorFn: (DataPoint sales, _) =>
            charts.ColorUtil.fromDartColor(sales.color),
        domainFn: (DataPoint sales, _) => sales.x,
        measureFn: (DataPoint sales, _) => sales.y,
        data: data,
      )
    ];
  }
}
