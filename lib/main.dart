import 'package:flutter/material.dart';
import 'package:shababi_caffee/pages/addRemoveTeam.dart';
import 'package:shababi_caffee/pages/editTeams.dart';
import 'package:shababi_caffee/pages/result.dart';
import 'package:sizer/sizer.dart';

import 'package:shababi_caffee/pages/CamScanner.dart';
import 'package:shababi_caffee/pages/HomeScreen.dart';

import 'pages/settings.dart';

void main() {
  runApp(Sizer(builder: (context, orientation, deviceType) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Shababi Caffee",
      initialRoute: HomeScreen.id,
      routes: {
        HomeScreen.id: (context) => const HomeScreen(),
        Settings.id: (context) => const Settings(),
        CamScanner.id: (context) => const CamScanner(),
        EditTeamsPage.id: (context) => const EditTeamsPage(),
        AddRemoveTeam.id: (context) => const AddRemoveTeam(),
        ResultPage.id: (context) => const ResultPage(),
      },
    );
  }));
}
