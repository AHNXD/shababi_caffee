// ignore_for_file: file_names

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static var ip = "http://192.168.1.2/shababi_caffee";

  static Future getTeams() async {
    final result = Uri.parse("$ip/api/getTeams.php");
    final response = await http.get(result);
    return json.decode(response.body);
  }

  static Future editTeam(var id, var ammount, var op) async {
    final result =
        Uri.parse("$ip/api/editTeam.php?ID=$id&ammount=$ammount&op=$op");
    final response = await http.get(result);
    return json.decode(response.body);
  }

  static Future deleteTeam(var id) async {
    final result = Uri.parse("$ip/api/deleteTeam.php?ID=$id");
    final response = await http.get(result);
    return json.decode(response.body);
  }

  static Future addTeam(var number, var name, var color) async {
    String encodedHexCode = Uri.encodeComponent(color);
    final result = Uri.parse(
        "$ip/api/addTeam.php?number=$number&name=$name&color=$encodedHexCode");
    final response = await http.get(result);
    return json.decode(response.body);
  }
}
