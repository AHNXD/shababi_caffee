import 'package:flutter/material.dart';
import 'package:shababi_caffee/const.dart';
import 'package:shababi_caffee/pages/addRemoveTeam.dart';
import 'package:shababi_caffee/pages/editTeams.dart';
import 'package:shababi_caffee/pages/result.dart';
import 'package:shababi_caffee/pages/settings.dart';

class HomeScreen extends StatefulWidget {
  static String id = "/Home";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // Determine screen width for responsive layout

    return Directionality(
      textDirection: TextDirection.rtl, // Ensure RTL for Arabic
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        resizeToAvoidBottomInset: false,

        // Custom Transparent AppBar to show the background header
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.2),
                child: IconButton(
                  onPressed: () => Navigator.pushNamed(context, Settings.id),
                  icon: const Icon(Icons.settings, color: Colors.white),
                ),
              ),
            )
          ],
        ),

        body: Column(
          children: [
            // --- 1. Custom Curved Header with Logo ---
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipPath(
                    clipper: HeaderClipper(),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            appColor,
                            const Color(0xFF1565C0), // Darker Blue
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 30), // Spacing for AppBar
                          Hero(
                            tag: 'logo',
                            child: Image.asset(
                              "assets/images/logo_robo.png",
                              height: 180,
                              fit: BoxFit.contain,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- 2. Menu Buttons Section ---
            Expanded(
              flex: 4,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Column(
                  children: [
                    // A. Big "Results" Card
                    _buildMenuCard(
                      context,
                      title: "الـنـتـائـج الـمـبـاشـرة",
                      icon: Icons.bar_chart_rounded,
                      color: Colors.orangeAccent,
                      onClick: () =>
                          Navigator.pushNamed(context, ResultPage.id),
                      isWide: true,
                    ),

                    const SizedBox(height: 16),

                    // B. Admin Tools Grid
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildMenuCard(
                              context,
                              title: "تـعـديـل النقاط",
                              icon: Icons.edit_note_rounded,
                              color: Colors.blueAccent,
                              onClick: () => Navigator.pushNamed(
                                  context, EditTeamsPage.id),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildMenuCard(
                              context,
                              title: "إدارة الـفـرق",
                              icon: Icons.groups_2_rounded, // or group_add
                              color: Colors.green,
                              onClick: () => Navigator.pushNamed(
                                  context, AddRemoveTeam.id),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onClick,
    bool isWide = false,
  }) {
    return Container(
      width: double.infinity,
      height: isWide
          ? 100
          : double.infinity, // Fixed height for wide card, expand for grid
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onClick,
          borderRadius: BorderRadius.circular(20),
          splashColor: color.withOpacity(0.1),
          highlightColor: color.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: isWide
                ? Row(
                    // Row layout for the wide card
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: color, size: 32),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.arrow_forward_ios_rounded,
                          color: Colors.grey[400], size: 20),
                    ],
                  )
                : Column(
                    // Column layout for grid cards
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: color, size: 40),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

// --- Custom Clipper for the curved header ---
class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50); // Start at bottom-left, slightly up

    // Create a quadratic bezier curve
    path.quadraticBezierTo(
        size.width / 2, // Control point x (middle)
        size.height, // Control point y (bottom)
        size.width, // End point x (right)
        size.height - 50 // End point y (slightly up)
        );

    path.lineTo(size.width, 0); // Line to top-right
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
