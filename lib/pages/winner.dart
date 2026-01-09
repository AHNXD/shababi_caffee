import 'dart:math';
import 'dart:ui'; // Required for ImageFilter (Blur)
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
    with TickerProviderStateMixin {
  // Changed to TickerProviderStateMixin for multiple controllers
  late ConfettiController _confettiController;
  late AnimationController _pulseController;
  late AnimationController _rotationController; // For background rays
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Confetti (Blast on start)
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 10));
    _confettiController.play();

    // 2. Pulse Animation for Avatar
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // 3. Rotation Animation for Sunburst
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Access winner data safely
    final String winnerName = winner["name"] ?? "البطل";
    final int winnerPoints = int.tryParse(winner["points"].toString()) ?? 0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // --- Layer 1: Deep Gradient Background ---
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  Color(0xFF1E88E5), // Light Blue center
                  Color(0xFF0D47A1), // Dark Blue edges
                  Color(0xFF000000), // Black corners
                ],
                stops: [0.0, 0.6, 1.0],
              ),
            ),
          ),

          // --- Layer 2: Rotating Sunburst Rays ---
          Positioned.fill(
            child: RotationTransition(
              turns: _rotationController,
              child: CustomPaint(
                painter: SunburstPainter(),
              ),
            ),
          ),

          // --- Layer 3: Confetti Shower ---
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              maxBlastForce: 20, // Stronger blast
              minBlastForce: 5,
              emissionFrequency: 0.02,
              numberOfParticles: 30,
              gravity: 0.05, // Float longer
              colors: const [
                Colors.amber,
                Colors.yellow,
                Colors.white,
                Colors.lightBlueAccent,
              ],
            ),
          ),

          // --- Layer 4: Main Content ---
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // --- THE WINNER AVATAR COMPONENT ---
              Stack(
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: [
                  // 1. The Avatar Circle
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // Gold Gradient Border
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFFD700), // Gold
                            Color(0xFFFFF176), // Light Yellow
                            Color(0xFFFFA000), // Amber
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.6),
                            blurRadius: 40,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0), // Border Width
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Rank Label
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    "1st Place",
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Initial or Logo
                                Text(
                                  winnerName.isNotEmpty
                                      ? winnerName[0].toUpperCase()
                                      : "W",
                                  style: TextStyle(
                                    fontSize: 80,
                                    fontWeight: FontWeight.w900,
                                    color: appColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 2. The Crown (Floating on top)
                  Positioned(
                    top: -60, // Adjust this based on your SVG size
                    child: SvgPicture.string(
                      crownImage,
                      width: 100,
                      height: 80,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 50),

              // --- THE INFO CARD (Glassmorphism) ---
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.1), // Semi-transparent white
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.2), width: 1),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "ألف مبروك للفائز", // "Congratulations to the winner"
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          winnerName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                  color: Colors.black45,
                                  blurRadius: 10,
                                  offset: Offset(0, 4))
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        // Points Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5))
                              ]),
                          child: Text(
                            "$winnerPoints نقطة",
                            style: TextStyle(
                              color: appColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 3),
            ],
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// CUSTOM PAINTER FOR BACKGROUND RAYS (Sunburst Effect)
// -----------------------------------------------------------------------------

class SunburstPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Center point
    final center = Offset(size.width / 2, size.height / 2);
    // Length of rays (diagonal of screen to ensure coverage)
    final radius = sqrt(size.width * size.width + size.height * size.height);

    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05) // Subtle white rays
      ..style = PaintingStyle.fill;

    // Number of rays
    const int rayCount = 12;
    const double angleStep = (2 * pi) / rayCount;

    for (int i = 0; i < rayCount; i++) {
      // Draw every other ray
      if (i % 2 == 0) {
        Path path = Path();
        path.moveTo(center.dx, center.dy);

        // Calculate arc segment for the ray
        double startAngle = i * angleStep;
        double endAngle = (i + 1) * angleStep;

        // Point 1 (Outer rim start)
        path.lineTo(
          center.dx + radius * cos(startAngle),
          center.dy + radius * sin(startAngle),
        );
        // Point 2 (Outer rim end)
        path.lineTo(
          center.dx + radius * cos(endAngle),
          center.dy + radius * sin(endAngle),
        );

        path.close();
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
