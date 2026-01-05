import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shababi_caffee/const.dart';
import 'package:shababi_caffee/pages/addRemoveTeam.dart';
import 'package:shababi_caffee/pages/editTeams.dart';
import 'package:shababi_caffee/pages/result.dart';
import 'package:shababi_caffee/pages/winner.dart';
import 'package:sizer/sizer.dart';

import 'package:shababi_caffee/pages/CamScanner.dart';
import 'package:shababi_caffee/pages/HomeScreen.dart';

import 'pages/settings.dart';

void main() {
  runApp(Sizer(builder: (context, orientation, deviceType) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: "cocon-next-arabic",
          colorScheme: ColorScheme.fromSeed(seedColor: appColor),
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.grey.shade200,
        ),
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
          WinnerScreen.id: (context) => const WinnerScreen(),
        },
      ),
    );
  }));
}
