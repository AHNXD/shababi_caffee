import 'dart:io';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:shababi_caffee/const.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WinnerScreen extends StatefulWidget {
  static String id = "/winner";
  const WinnerScreen({super.key});

  @override
  State<WinnerScreen> createState() => _WinnerScreenScreenState();
}

class _WinnerScreenScreenState extends State<WinnerScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 10));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void massege(String error, Color c) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: c,
      content: Center(child: Text(error)),
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          Platform.isAndroid || Platform.isIOS ? false : true,
      appBar: AppBar(
        backgroundColor: appColor,
        centerTitle: true,
        title: const Text(
          "مـنـصـة الـتـتـويـج",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ConfettiWidget(
                  numberOfParticles: 20,
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: true,
                  colors: const [
                    Colors.red,
                    Colors.blue,
                    Colors.green,
                    Colors.yellow
                  ],
                ),
                ConfettiWidget(
                  numberOfParticles: 20,
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: true,
                  colors: const [
                    Colors.red,
                    Colors.blue,
                    Colors.green,
                    Colors.yellow
                  ],
                ),
                ConfettiWidget(
                  numberOfParticles: 20,
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: true,
                  colors: const [
                    Colors.red,
                    Colors.blue,
                    Colors.green,
                    Colors.yellow
                  ],
                ),
                ConfettiWidget(
                  numberOfParticles: 20,
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: true,
                  colors: const [
                    Colors.red,
                    Colors.blue,
                    Colors.green,
                    Colors.yellow
                  ],
                ),
              ],
            ),
          ),
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 16),
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: appColor,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(60),
                          bottomRight: Radius.circular(60))),
                  child: Image.asset("assets/images/logo.png"),
                ),
                const Spacer(
                  flex: 1,
                ),
                SvgPicture.string(
                  crownImage,
                  width: 200,
                ),
                CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 224, 224, 224),
                  radius: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${winner["name"]}\n",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: appColor),
                      ),
                      Text(
                        "${winner["points"]}",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: appColor),
                      ),
                    ],
                  ),
                ),
                const Spacer(
                  flex: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
