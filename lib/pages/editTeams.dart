// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:shababi_caffee/const.dart';
import 'package:shababi_caffee/services/apiService.dart';

class EditTeamsPage extends StatefulWidget {
  static String id = "/edit";
  const EditTeamsPage({super.key});

  @override
  State<EditTeamsPage> createState() => _EditTeamsPageState();
}

class _EditTeamsPageState extends State<EditTeamsPage> {
  int selectedValue = 5;

  List<DropdownMenuItem<int>> menuItems = [
    const DropdownMenuItem(value: 5, child: Text("5")),
    const DropdownMenuItem(value: 10, child: Text("10")),
    const DropdownMenuItem(value: 15, child: Text("15")),
    const DropdownMenuItem(value: 20, child: Text("20")),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appColor,
          centerTitle: true,
          title: const Text(
            "تـعـديـل",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: FutureBuilder(
              future: ApiService.getTeams(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  var teams = snapshot.data;
                  if (teams['status'] == "success") {
                    teams = teams['teams'];
                    return ListView.builder(
                        itemCount: teams.length,
                        itemBuilder: (BuildContext BuildContext, int index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: toColor(teams[index]['color']),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${teams[index]['name']}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 30),
                                ),
                                Text(
                                  "${teams[index]['points']}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 25),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                          onPressed: () async {
                                            await ApiService.editTeam(
                                                teams[index]['ID'],
                                                selectedValue,
                                                'add');
                                            setState(() {});
                                          },
                                          icon: const Icon(
                                            Icons.add,
                                            size: 30,
                                          )),
                                      DropdownButton<int>(
                                        value: selectedValue,
                                        items: menuItems,
                                        onChanged: (int? newValue) {
                                          setState(() {
                                            selectedValue = newValue!;
                                          });
                                        },
                                      ),
                                      IconButton(
                                          onPressed: () async {
                                            await ApiService.editTeam(
                                                teams[index]['ID'],
                                                selectedValue,
                                                'sub');
                                            setState(() {});
                                          },
                                          icon: const Icon(
                                            Icons.remove,
                                            size: 30,
                                          )),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                  }
                  return const Text("أعـد الـمـحـاولـة");
                } else {
                  return CircularProgressIndicator(
                    color: appColor,
                  );
                }
              }),
        ),
      ),
    );
  }
}
