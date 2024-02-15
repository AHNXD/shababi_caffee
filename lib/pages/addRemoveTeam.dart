// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shababi_caffee/const.dart';
import 'package:shababi_caffee/services/apiService.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class AddRemoveTeam extends StatefulWidget {
  static String id = "/ARTeam";
  const AddRemoveTeam({super.key});

  @override
  State<AddRemoveTeam> createState() => _AddRemoveTeamState();
}

class _AddRemoveTeamState extends State<AddRemoveTeam> {
  TextEditingController number_controller = TextEditingController();
  TextEditingController name_controller = TextEditingController();
  Color _color = appColor;
  late String hexString;
  late String colorCode;
  @override
  void initState() {
    super.initState();
    hexString = _color.value.toRadixString(16);
    colorCode = '#$hexString';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: BottomAppBar(
          color: appColor,
          height: 32,
        ),
        appBar: AppBar(
          backgroundColor: appColor,
          centerTitle: true,
          title: const Text(
            "إضـافـة/حـذف",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.add,
              color: appColor,
              size: 32,
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => SingleChildScrollView(
                        child: AlertDialog(
                          title: const Text(
                            ":مـعـلـومـات الـفـريـق",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 30),
                          ),
                          content: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // team number
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: number_controller,
                                    decoration: InputDecoration(
                                      labelStyle:
                                          const TextStyle(color: Colors.white),
                                      labelText: "الـرقـم",
                                      hintText: "أدخـل رقـم الـفـريـق",
                                      prefixIcon: const Icon(
                                        Icons.format_list_numbered_sharp,
                                        color: Colors.black,
                                      ),
                                      fillColor: Colors.red[900],
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.white, width: 2),
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black, width: 2),
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                // team name
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: name_controller,
                                    decoration: InputDecoration(
                                      labelStyle:
                                          const TextStyle(color: Colors.white),
                                      labelText: "الأسـم",
                                      hintText: "أدخـل أسـم الـفـريـق",
                                      prefixIcon: const Icon(
                                        Icons.format_list_numbered_sharp,
                                        color: Colors.black,
                                      ),
                                      fillColor: Colors.red[900],
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.white, width: 2),
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black, width: 2),
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                    ),
                                    keyboardType: TextInputType.text,
                                  ),
                                ),
                                // team color
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      color: Colors.white),
                                  child: ColorPicker(
                                    pickerColor: _color,
                                    pickerAreaHeightPercent: 0.5,
                                    onColorChanged: (color) {
                                      setState(() {
                                        _color = color;
                                        hexString =
                                            _color.value.toRadixString(16);
                                        colorCode = '#$hexString';
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () async {
                                await ApiService.addTeam(number_controller.text,
                                    name_controller.text, colorCode);
                                Navigator.pop(context);
                                setState(() {});
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  padding: const EdgeInsets.all(20),
                                  elevation: 20,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20)))),
                              child: Text(
                                "إضـافـة",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: appColor,
                                ),
                              ),
                            )
                          ],
                          backgroundColor: appColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ));
            }),
        body: DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
              opacity: 0.4,
              image: AssetImage("assets/images/logo.png"),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60),
                                  border: Border.all(
                                      color: toColor(teams[index]['color']),
                                      width: 5)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        teams[index]['name'],
                                        style: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        teams[index]['points'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      IconButton(
                                          onPressed: () async {
                                            await ApiService.deleteTeam(
                                                teams[index]['ID']);
                                            setState(() {});
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ))
                                    ]),
                              ));
                        });
                  } else {
                    return const Text("أعـد الـمـحـاولـة");
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: appColor,
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
