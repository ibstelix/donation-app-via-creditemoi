import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showFormValidationToast(
    [content = 'Certains champs ne sont pas valides',
    color = Colors.blueGrey]) {
  Fluttertoast.showToast(
      msg: content,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 2,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0);
}

Future showSnackBar(BuildContext context, String text,
    {bool status: false, int duration: 3}) async {
  Color color = Colors.red;
  if (status) {
    color = Colors.blue[300];
  }
  return Flushbar(
    message: text,
    icon: Icon(
      Icons.info_outline,
      size: 28.0,
      color: color,
    ),
    duration: Duration(seconds: duration),
    leftBarIndicatorColor: color,
  )..show(context);
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

isNumeric(string) => num.tryParse(string) != null;
