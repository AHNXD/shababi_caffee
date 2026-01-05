import 'dart:math'; 
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:shababi_caffee/const.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WinnerScreen extends StatefulWidget {
  static String id = "/winner";
  const WinnerScreen({super.key});

  @override
  State<WinnerScreen> createState() => _WinnerScreenState();
}

class _WinnerScreenState extends State<WinnerScreen>
    with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // 1. Setup Confetti
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 10));
    _confettiController.play();

    // 2. Setup Pulse Animation for the Avatar
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true); // Breath in, breath out

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Allows background to cover full screen
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "مـنـصـة الـتـتـويـج",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
              color: Colors.white,
              shadows: [
                Shadow(
                    color: Colors.black45, blurRadius: 10, offset: Offset(0, 2))
              ]),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // --- Layer 1: Background Gradient ---
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  appColor,
                  const Color(0xFF1565C0), // Darker shade for depth
                  const Color(0xFF0D47A1),
                ],
              ),
            ),
          ),

          // --- Layer 2: Background Watermark ---
          Positioned(
            top: 150,
            child: Opacity(
              opacity: 0.1,
              child: Image.asset("assets/images/logo_robo.png", width: 350),
            ),
          ),

          // --- Layer 3: Confetti (Top Center Shower) ---
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2, // Downwards
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.1,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
                Colors.yellow
              ],
            ),
          ),

          // --- Layer 4: Main Content ---
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3), // Push content down slightly

              // 1. Crown Icon
              SvgPicture.string(
                crownImage, // Ensure your SVG string in const.dart is valid
                width: 100,
                height: 100,
                // Optional: colorFilter: const ColorFilter.mode(Colors.amber, BlendMode.srcIn),
              ),

              const SizedBox(height: 20),

              // 2. Animated Winner Avatar
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  padding: const EdgeInsets.all(6), // Gold Border Width
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [
                        Colors.amber,
                        Colors.yellowAccent,
                        Colors.orange
                      ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.amber,
                            blurRadius: 30,
                            spreadRadius: 5) // Glow effect
                      ]),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 110,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          winner["name"] ?? "Winner",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: appColor,
                              height: 1.2),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                              color: appColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "${winner["points"] ?? 0} PTS",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 4),

              // 3. Footer Text
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Text(
                  "CONGRATULATIONS!",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
