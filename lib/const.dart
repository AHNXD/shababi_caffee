import 'package:flutter/material.dart';

var appColor = Colors.orange;

Color toColor(String c) {
  var hexString = c;
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}
