// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shababi_caffee/const.dart';
import 'package:shababi_caffee/pages/addRemoveTeam.dart';
import 'package:shababi_caffee/pages/editTeams.dart';
import 'package:shababi_caffee/pages/result.dart';
import 'package:shababi_caffee/pages/settings.dart';
import 'package:shababi_caffee/services/apiService.dart';

class HomeScreen extends StatefulWidget {
  static String id = "/Home";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        resizeToAvoidBottomInset: Platform.isAndroid ? false : true,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, Settings.id);
                },
                icon: const Icon(Icons.settings))
          ],
          backgroundColor: appColor,
          centerTitle: true,
          title: const Text(
            "الـصـفـحـة الـرئـيـسـيـة",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset("assets/images/logo.png"),
                ListView(
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: appColor),
                          onPressed: () async {
                            try {
                              var result = await ApiService.checkConn();
                              if (result['status'] == "success") {
                                Navigator.pushNamed(context, ResultPage.id);
                              } else {
                                massege("حـدث خـطـأ بـالإتـصـال", Colors.red);
                              }
                            } catch (e) {
                              massege("الـرجـاء إعـادة الـمـاولـة", Colors.red);
                            }
                          },
                          child: const Text(
                            "الـنـتـائـج",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: appColor),
                          onPressed: () async {
                            try {
                              var result = await ApiService.checkConn();
                              if (result['status'] == "success") {
                                Navigator.pushNamed(context, AddRemoveTeam.id);
                              } else {
                                massege("حـدث خـطـأ بـالإتـصـال", Colors.red);
                              }
                            } catch (e) {
                              massege("الـرجـاء إعـادة الـمـاولـة", Colors.red);
                            }
                          },
                          child: const Text(
                            "اضـافـة/حـذف",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: appColor),
                          onPressed: () async {
                            try {
                              var result = await ApiService.checkConn();
                              if (result['status'] == "success") {
                                Navigator.pushNamed(context, EditTeamsPage.id);
                              } else {
                                massege("حـدث خـطـأ بـالإتـصـال", Colors.red);
                              }
                            } catch (e) {
                              massege("الـرجـاء إعـادة الـمـاولـة", Colors.red);
                            }
                          },
                          child: const Text(
                            "تـعـديـل",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
