// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:shababi_caffee/const.dart';
import 'package:shababi_caffee/services/apiService.dart';

class AddRemoveTeam extends StatefulWidget {
  static String id = "/ARTeam";
  const AddRemoveTeam({super.key});

  @override
  State<AddRemoveTeam> createState() => _AddRemoveTeamState();
}

class _AddRemoveTeamState extends State<AddRemoveTeam> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appColor,
          centerTitle: true,
          title: const Text(
            "إضـافـة/حـذف",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.add,
              color: appColor,
              size: 32,
            ),
            onPressed: () {}),
        body: FutureBuilder(
          future: ApiService.getTeams(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              var teams = snapshot.data;
              if (teams['status'] == "success") {
                teams = teams['teams'];
                return ListView.builder(
                    itemCount: teams.length,
                    itemBuilder: (BuildContext BuildContext, int index) {
                      return Center();
                    });
              } else {
                return const Text("أعـد الـمـحـاولـة");
              }
            } else {
              return CircularProgressIndicator(
                color: appColor,
              );
            }
          },
        ),
      ),
    );
  }
}
