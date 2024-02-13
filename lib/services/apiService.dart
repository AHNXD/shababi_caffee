// ignore_for_file: file_names

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static var ip = "http://192.168.1.2/shababi_caffee";

  //get
  static Future getTeams() async {
    final result = Uri.parse("$ip/api/getTeams.php");
    final response = await http.get(result);
    return json.decode(response.body);
  }

//get
  static Future editTeam(var id, var ammount, var op) async {
    final result =
        Uri.parse("$ip/api/editTeam.php?ID=$id&ammount=$ammount&op=$op");
    final response = await http.get(result);
    return json.decode(response.body);
  }
}
