// ignore_for_file: file_names, non_constant_identifier_names

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
    return Scaffold(
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
                          onPressed: () {
                            Navigator.pushNamed(context, ResultPage.id);
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
                          onPressed: () {
                            Navigator.pushNamed(context, AddRemoveTeam.id);
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
                          onPressed: () {
                            Navigator.pushNamed(context, EditTeamsPage.id);
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
