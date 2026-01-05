// ignore_for_file: prefer_typing_uninitialized_variables
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shababi_caffee/const.dart';
import 'package:shababi_caffee/pages/winner.dart';
import 'package:shababi_caffee/services/apiService.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ResultPage extends StatefulWidget {
  static String id = "/Result";

  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  // State Variables
  List<DataPoint> _dataPoints = [];

  // Timers
  Timer? _dataFetchTimer; // Timer for API calls
  Timer? _gameTimer; // Timer for the countdown

  int _timerDuration = time * 60; // Configured time in seconds
  bool _isTimerRunning = false;

  // Audio
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Initial Fetch
    _fetchData();

    // Start background data fetching (Every 2 seconds is usually sufficient/safer than 1s)
    _dataFetchTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _fetchData();
    });
  }

  @override
  void dispose() {
    _dataFetchTimer?.cancel();
    _gameTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  // --- Logic Section ---

  Future<void> _fetchData() async {
    if (!mounted) return;
    try {
      var response = await ApiService.getTeams();
      if (response['status'] == "success") {
        var teams = response["teams"];

        // Update Global Winner Logic
        for (var team in teams) {
          int teamPoints = int.tryParse(team["points"].toString()) ?? 0;
          int currentMax = int.tryParse(winner["points"].toString()) ?? 0;

          if (teamPoints >= currentMax) {
            winner["name"] = team["name"];
            winner["points"] = team["points"];
          }
        }

        if (mounted) {
          setState(() {
            _dataPoints = teams.map<DataPoint>((team) {
              return DataPoint(
                team['name'],
                double.tryParse(team['points'].toString()) ?? 0.0,
                toColor(team['color']),
              );
            }).toList();
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
    }
  }

  void _startGameTimer() {
    if (_isTimerRunning) return;

    setState(() {
      _isTimerRunning = true;
    });

    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      if (_timerDuration > 0) {
        setState(() => _timerDuration--);

        // Sound Triggers
        if (_timerDuration == 60) _playSound("audio/1min.mp3");
        if (_timerDuration == 10) _playSound("audio/10s.mp3");
      } else {
        _stopGameTimer();
      }
    });
  }

  void _stopGameTimer() {
    _gameTimer?.cancel();
    _audioPlayer.stop();
    setState(() {
      _isTimerRunning = false;
    });
  }

  void _resetGameTimer() {
    _stopGameTimer();
    setState(() {
      _timerDuration = time * 60;
    });
  }

  void _playSound(String path) async {
    try {
      await _audioPlayer.stop(); // Stop previous if any
      await _audioPlayer.play(AssetSource(path));
    } catch (e) {
      debugPrint("Audio Error: $e");
    }
  }

  // --- UI Section ---

  @override
  Widget build(BuildContext context) {
    bool isWindows = Platform.isWindows;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: _buildAppBar(isWindows),
        body: Stack(
          children: [
            // Background Watermark
            Positioned.fill(
              child: Opacity(
                opacity: 0.1,
                child: Image.asset(
                  "assets/images/logo_robo.png",
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // Main Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: _dataPoints.isNotEmpty
                        ? _buildChartCard(isWindows)
                        : Center(
                            child: CircularProgressIndicator(color: appColor)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isWindows) {
    return AppBar(
      backgroundColor: appColor,
      centerTitle: true,
      elevation: 0,
      title: isWindows
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("النتائج المباشرة",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                const SizedBox(width: 20),
                _buildDigitalClock(),
              ],
            )
          : const Text("الـنـتـائـج",
              style: TextStyle(fontWeight: FontWeight.bold)),
      actions: _buildActions(isWindows),
    );
  }

  Widget _buildDigitalClock() {
    String minutes = (_timerDuration ~/ 60).toString().padLeft(2, '0');
    String seconds = (_timerDuration % 60).toString().padLeft(2, '0');

    // Dynamic color based on urgency
    Color timeColor = Colors.black87;
    Color bgColor = Colors.white;

    if (int.parse(minutes) == 0) {
      if (int.parse(seconds) <= 10) {
        timeColor = Colors.red; // Critical
        if (int.parse(seconds) % 2 == 0)
          bgColor = Colors.red.shade100; // Flash effect
      } else if (int.parse(seconds) <= 30) {
        timeColor = Colors.orange[800]!;
      }
    } else if (int.parse(minutes) >= 1) {
      timeColor = Colors.green[800]!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Text(
        "$minutes:$seconds",
        style: TextStyle(
          color: timeColor,
          fontWeight: FontWeight.bold,
          fontSize: 24,
          fontFamily: 'Courier', // Monospaced font looks better for numbers
        ),
      ),
    );
  }

  Widget _buildChartCard(bool isWindows) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SfCartesianChart(
          plotAreaBorderWidth: 0,
          title: ChartTitle(
            text: isWindows ? 'إحصائيات الفرق' : '',
            textStyle: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          primaryXAxis: CategoryAxis(
            majorGridLines: const MajorGridLines(width: 0), // Clean look
            labelStyle: TextStyle(
                fontSize: isWindows ? 20 : 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          primaryYAxis: NumericAxis(
            isVisible: true,
            axisLine: const AxisLine(width: 0),
            majorTickLines: const MajorTickLines(size: 0),
          ),
          series: <CartesianSeries>[
            ColumnSeries<DataPoint, String>(
              animationDuration: 800,
              dataSource: _dataPoints,
              xValueMapper: (DataPoint data, _) => data.x,
              yValueMapper: (DataPoint data, _) => data.y,
              pointColorMapper: (DataPoint data, _) => data.color,
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15)), // Rounded bars
              width: 0.6, // Spacing between bars
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                textStyle: TextStyle(
                  fontSize: isWindows ? 22 : 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Ensure contrast
                ),
                labelAlignment:
                    ChartDataLabelAlignment.outer, // Place number on top of bar
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActions(bool isWindows) {
    List<Widget> actions = [];

    // 1. Timer Controls (Windows Only)
    if (isWindows) {
      if (_isTimerRunning) {
        actions.add(IconButton(
          icon: const Icon(Icons.pause_circle_filled, size: 30),
          onPressed: _stopGameTimer,
          tooltip: "إيقاف مؤقت",
        ));
        actions.add(IconButton(
          icon: const Icon(Icons.restart_alt, size: 30),
          onPressed: _resetGameTimer,
          tooltip: "إعادة تعيين",
        ));
      } else {
        actions.add(IconButton(
          icon: const Icon(Icons.play_circle_fill, size: 30),
          onPressed: _startGameTimer,
          tooltip: "بدء المؤقت",
        ));
      }
    }

    // 2. Winner Page Button
    actions.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Center(
          child: InkWell(
            onTap: () => Navigator.pushNamed(context, WinnerScreen.id),
            borderRadius: BorderRadius.circular(50),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.string(
                trophy, // Ensure this string is valid SVG XML in your const.dart
                height: 24,
                width: 24,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
          ),
        ),
      ),
    );

    return actions;
  }
}

// Data Model
class DataPoint {
  final String x;
  final double y;
  final Color color;

  DataPoint(this.x, this.y, this.color);
}
