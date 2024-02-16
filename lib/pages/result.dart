// ignore_for_file: prefer_typing_uninitialized_variables
import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
// Import just_audio package
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
  int _timerDuration = time * 60; // 45 minutes in seconds
  bool _isTimerRunning = false;
  // Audio player instance
  String audioasset = "audio/beep.mp3";

  bool _shouldPlayBeep = false;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _fetchData(); // Initial data fetch
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _fetchData(); // Fetch data every second
    });
    // Initialize audio player
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _stopBeep(); // Cancel timer to prevent memory leaks
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

  void _startTimer() {
    setState(() {
      _isTimerRunning = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_timerDuration > 0) {
          setState(() {
            _timerDuration--;
          });
        } else {
          _timer.cancel();
          _isTimerRunning = false;
          // Timer completed action here
        }
        _updateBeepStatus(); // Check if beep should be played
      });
    });
  }

  void _stopTimer() {
    setState(() {
      _isTimerRunning = false;
      _timer.cancel();
      _stopBeep(); // Stop the beep sound
    });
  }

  void _stopBeep() {
    _audioPlayer.stop(); // Stop playing the beep sound
  }

  void _resetTimer() {
    setState(() {
      _isTimerRunning = false;
      _timer.cancel();
      _timerDuration = time * 60; // Reset timer duration to 45 minutes
    });
  }

  // Check if beep should be played
  void _updateBeepStatus() {
    if (_timerDuration <= 55 && _timerDuration > 0) {
      _shouldPlayBeep = true;
    } else {
      _shouldPlayBeep = false;
    }
    if (_shouldPlayBeep) {
      _playBeep(); // Play beep sound
    }
  }

  // Play beep sound
  void _playBeep() async {
    await _audioPlayer.play(AssetSource(audioasset));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset:
            Platform.isAndroid || Platform.isIOS ? false : true,
        appBar: AppBar(
          backgroundColor: appColor,
          centerTitle: true,
          title: Column(
            children: [
              const Text(
                "الـنـتـائـج",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              _buildTimer(),
            ],
          ),
          actions: _buildAppBarActions(),
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
      ),
    );
  }

  Widget _buildTimer() {
    String minutes = (_timerDuration ~/ 60).toString().padLeft(2, '0');
    String seconds = (_timerDuration % 60).toString().padLeft(2, '0');
    return Text(
      '$minutes:$seconds',
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
          color: int.parse(minutes) < 1 ? Colors.red : Colors.black),
    );
  }

  List<Widget> _buildAppBarActions() {
    if (_isTimerRunning) {
      return [
        IconButton(
          onPressed: _stopTimer,
          icon: const Icon(Icons.pause),
        ),
        IconButton(
          onPressed: _resetTimer,
          icon: const Icon(Icons.stop),
        ),
      ];
    } else {
      return [
        IconButton(
          onPressed: _startTimer,
          icon: const Icon(Icons.play_arrow),
        ),
      ];
    }
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
      domainAxis: charts.OrdinalAxisSpec(
        showAxisLine: true,
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: const charts.TextStyleSpec(
            fontSize: 35,
          ),
          labelRotation: Platform.isAndroid || Platform.isIOS ? 45 : 0,
        ),
      ),
      defaultRenderer: charts.BarRendererConfig(
        cornerStrategy: const charts.ConstCornerStrategy(15),
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
