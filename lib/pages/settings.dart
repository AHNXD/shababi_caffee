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
  static final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _retrieveIp();
    setState(() {
      _controller.text = ApiService.ip;
    });
  }

  void massege(String error, Color c) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: c,
      content: Center(child: Text(error)),
      duration: const Duration(seconds: 2),
    ));
  }

  Future<void> _retrieveIp() async {
    final prefs = await SharedPreferences.getInstance();

    // Check where the Ip is saved before or not
    if (!prefs.containsKey('ip')) {
      return;
    }

    setState(() {
      _controller.text = prefs.getString('ip')!;
      ApiService.ip = _controller.text;
    });
  }

  Future<void> _saveIp() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('ip', _controller.text);
  }

  void _clearIp() {
    _controller.text = "";
    setState(() {});
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
          title: const Text(
            "الإعـدادات",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
              opacity: 0.4,
              image: AssetImage("assets/images/logo.png"),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "الـعـنـوان :",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: appColor),
                      labelText: "الـعـنـوان",
                      hintText: "ادخـل الـعـنـوان",
                      prefixIcon: const Icon(
                        Icons.numbers,
                        color: Colors.amber,
                      ),
                      suffixIcon: IconButton(
                          onPressed: () async {
                            var aux = await Navigator.pushNamed(
                                context, CamScanner.id);
                            if (aux != null) _controller.text = aux as String;
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.qr_code_2,
                            color: appColor,
                          )),
                      fillColor: appColor,
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(25)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: appColor, width: 2),
                          borderRadius: BorderRadius.circular(25)),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_controller.text != "") {
                          _saveIp();
                          ApiService.ip = _controller.text;
                          massege("تـم الـحـفـظ", appColor);
                        } else {
                          massege("يـرجـى ادخـال الـعـوان", Colors.red);
                        }
                      },
                      style:
                          ElevatedButton.styleFrom(backgroundColor: appColor),
                      child: const Text(
                        "حـفـظ",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_controller.text != "") {
                          _clearIp();
                          massege("تـم الـذف", appColor);
                        }
                      },
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text(
                        "حـذف",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
