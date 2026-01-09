// ignore_for_file: file_names

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class ApiService {
  static var ip = "http://localhost:8000";

  static Future getTeams() async {
    final result = Uri.parse("$ip/get_team");
    final response = await http.get(result);
    log(response.body.toString());
    return json.decode(response.body);
  }

  static Future addTeam(var number, var name, var color) async {
    final url =
        Uri.parse("$ip/add_team?number=$number&name=$name&color=$color");
    final response = await http.get(url);
    log(response.body.toString());
    return json.decode(response.body);
  }

  static Future editTeam(var id, var ammount, var op) async {
    final url = Uri.parse("$ip/edit_team?ID=$id&ammount=$ammount&op=$op");
    final response = await http.get(url);
    log(response.body.toString());
    return json.decode(response.body);
  }

  static Future deleteTeam(var id) async {
    final url = Uri.parse("$ip/delete_team?ID=$id");
    final response = await http.get(url);
    log(response.body.toString());
    return json.decode(response.body);
  }
}
