// ignore_for_file: prefer_typing_uninitialized_variables
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shababi_caffee/const.dart';
import 'package:shababi_caffee/pages/winner.dart';
import 'package:shababi_caffee/services/apiService.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // Import Syncfusion chart package

class ResultPage extends StatefulWidget {
  static String id = "/Result";

  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  List<DataPoint> _dataPoints = [];
  late Timer _timer;
  int _timerDuration = time * 60; // 45 minutes in seconds
  bool _isTimerRunning = false;

  // Audio player instance
  String audioasset = "audio/10s.mp3";

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
    if (!mounted) return;
    var teams = await ApiService.getTeams();
    if (teams['status'] == "success") {
      teams = teams["teams"];
      for (var team in teams) {
        if (int.parse(team["points"]) >= int.parse(winner["points"])) {
          winner["name"] = team["name"];
          winner["points"] = team["points"];
        }
      }
      if (!mounted) return;
      {
        try {
          setState(() {
            _dataPoints = teams.map<DataPoint>((team) {
              return DataPoint(
                team['name'],
                double.parse(team['points']),
                toColor(team['color']),
              );
            }).toList();
          });
        } catch (e) {
          print("The error when dispose: $e");
        }
      }
    }
  }

  void _startTimer() {
    setState(() {
      _isTimerRunning = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          // Check if widget is still mounted
          if (_timerDuration > 0) {
            setState(() {
              _timerDuration--;
            });
            if (_timerDuration == 10) {
              _playBeep();
            }
          } else {
            _timer.cancel();
            _isTimerRunning = false;
            // Timer completed action here
          }
          // Check if beep should be played
        }
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

  // Play beep sound
  void _playBeep() async {
    try {
      await _audioPlayer.play(AssetSource(audioasset));
    } catch (e) {
      print("Error playing beep: $e");
    }
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "الـنـتـائـج",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Platform.isWindows
                  ? Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16)),
                      child: _buildTimer())
                  : const SizedBox(),
              const SizedBox(
                width: 8,
              )
            ],
          ),
          actions: Platform.isWindows
              ? _buildAppBarActions()
              : [
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, WinnerScreen.id);
                        },
                        child: SvgPicture.string(
                          trophy,
                          height: 25,
                          width: 25,
                        )),
                  ),
                ],
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
                  ? SfCartesianChart(
                      primaryXAxis: Platform.isWindows
                          ? CategoryAxis(
                              labelStyle: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold))
                          : CategoryAxis(),
                      series: <ChartSeries>[
                        ColumnSeries<DataPoint, String>(
                          animationDuration: 200,
                          dataSource: _dataPoints,
                          xValueMapper: (DataPoint data, _) => data.x,
                          yValueMapper: (DataPoint data, _) => data.y,
                          pointColorMapper: (DataPoint data, _) => data.color,
                          dataLabelSettings: DataLabelSettings(
                              isVisible: true,
                              textStyle: Platform.isWindows
                                  ? const TextStyle(
                                      fontSize: 30, fontWeight: FontWeight.bold)
                                  : const TextStyle(
                                      fontSize: 18,
                                    )),
                        )
                      ],
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
          color: int.parse(minutes) >= 1
              ? Colors.green
              : int.parse(seconds) > 30
                  ? Colors.red
                  : int.parse(seconds) % 2 == 0
                      ? Colors.red
                      : Colors.black),
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
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, WinnerScreen.id);
              },
              child: SvgPicture.string(
                trophy,
                height: 25,
                width: 25,
              )),
        ),
      ];
    } else {
      return [
        IconButton(
          onPressed: _startTimer,
          icon: const Icon(Icons.play_arrow),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, WinnerScreen.id);
              },
              child: SvgPicture.string(
                trophy,
                height: 25,
                width: 25,
              )),
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
