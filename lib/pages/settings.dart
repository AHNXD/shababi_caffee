import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shababi_caffee/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shababi_caffee/pages/CamScanner.dart';
import '../services/apiService.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});
  static String id = "/settings";
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    // Set initial time from global variable
    _timeController.text = time.toString();

    // Retrieve saved IP
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('ip')) {
      String? savedIp = prefs.getString('ip');
      if (savedIp != null) {
        setState(() {
          _ipController.text = savedIp;
          ApiService.ip = savedIp;
        });
      }
    } else {
      // If no IP saved, pre-fill with current API IP
      setState(() {
        _ipController.text = ApiService.ip;
      });
    }
  }

  Future<void> _saveIp() async {
    if (_ipController.text.trim().isEmpty) {
      _showMessage("يرجى إدخال العنوان أولاً", Colors.red);
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ip', _ipController.text.trim());
    ApiService.ip = _ipController.text.trim();
    _showMessage("تم حفظ عنوان الخادم بنجاح", Colors.green);
  }

  void _clearIp() {
    setState(() {
      _ipController.clear();
    });
    _showMessage("تم مسح الحقل", Colors.orange);
  }

  void _saveTime() {
    if (_timeController.text.trim().isEmpty) return;
    setState(() {
      time = int.parse(_timeController.text);
    });
    _showMessage("تم تحديث وقت المباراة: $time دقيقة", Colors.green);
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.white),
          const SizedBox(width: 10),
          Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[50], // Cleaner background
        appBar: AppBar(
          backgroundColor: appColor,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "الإعـدادات",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
        ),
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
            SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  // --- Section 1: Server Connection ---
                  _buildSectionCard(
                    title: "إعدادات الاتصال",
                    icon: Icons.wifi,
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _ipController,
                          label: "عنوان الخادم (IP)",
                          hint: "مثال: 192.168.1.5",
                          icon: Icons.computer,
                          suffix: IconButton(
                            icon: Icon(Icons.qr_code_scanner, color: appColor),
                            onPressed: () async {
                              var result = await Navigator.pushNamed(
                                  context, CamScanner.id);
                              if (result != null && result is String) {
                                setState(() => _ipController.text = result);
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _saveIp,
                                icon: const Icon(Icons.save_alt,
                                    color: Colors.white),
                                label: const Text("حـفـظ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: appColor,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            OutlinedButton(
                              onPressed: _clearIp,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 20),
                                side: const BorderSide(color: Colors.red),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Text("مسح",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // --- Section 2: Game Settings (Windows Only) ---
                  if (Platform.isWindows)
                    _buildSectionCard(
                      title: "إعدادات اللعبة",
                      icon: Icons.timer,
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _timeController,
                              label: "وقت المباراة (دقائق)",
                              hint: "45",
                              icon: Icons.watch_later_outlined,
                              inputType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 15),
                          ElevatedButton(
                            onPressed: _saveTime,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: appColor,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 24),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            child: const Icon(Icons.check, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(
      {required String title, required IconData icon, required Widget child}) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: appColor, size: 28),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800]),
                ),
              ],
            ),
            const Divider(height: 30),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    Widget? suffix,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      style: const TextStyle(fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: appColor, width: 2),
        ),
      ),
    );
  }
}
