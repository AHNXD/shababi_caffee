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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[50], // Very light grey for contrast
        body: Column(
          children: [
            // --- 1. NEW HEADER STYLE: Floating Circle ---
            Stack(
              clipBehavior: Clip.none, // Allows the logo to hang off the bottom
              alignment: Alignment.center,
              children: [
                // A. The Blue Background Banner
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        appColor,
                        const Color(0xFF1565C0),
                      ],
                    ),
                    // Soft rounded corners at the bottom
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),

                // B. The Top Bar (Title & Settings)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, Settings.id),
                              icon: const Icon(Icons.settings,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // C. The Logo (Floating "Avatar" Style)
                // Positioned so half is on blue, half on white
                Positioned(
                  bottom: -60,
                  child: Container(
                    height: 180,
                    width: 180,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Hero(
                      tag: 'logo',
                      child: Image.asset(
                        "assets/icons/icon.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Add spacing to push content down below the floating logo
            const SizedBox(height: 80),

            // --- 2. Menu Buttons Section ---
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    // Results Button
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

                    // Admin Tools Grid
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
                              icon: Icons.groups_2_rounded,
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

  // Same menu card logic as before
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
      height: isWide ? 100 : double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                          fontSize: 20, // Slightly smaller for balance
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.arrow_forward_ios_rounded,
                          color: Colors.grey[400], size: 18),
                    ],
                  )
                : Column(
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
