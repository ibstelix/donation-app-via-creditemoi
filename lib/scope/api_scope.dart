import 'dart:convert';

import 'package:codedecoders/strings/const.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class ApiScope extends Model {
  Map _selected_transaction;

  Map get selected_transaction => _selected_transaction;

  set selected_transaction(Map value) {
    _selected_transaction = value;
    notifyListeners();
  }

  //**************************************
  Future<Map> post_noToken(Map data, String url) async {
    try {
      http.Response response = await http.post(url, body: data);
//      alice.onHttpResponse(response);

      final Map<String, dynamic> res = json.decode(response.body);
//      print("resultat map is $res");

      if (response.statusCode != 200) {
        return raisedException(res['msg'], url);
      }
      return {"status": true, "msg": res};
    } catch (err) {
      return errorException(err);
    }
  }

  Future<Map> post_api(Map data, String url, [has_token = false]) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString(TOKEN);
      if (has_token && token == null) {
        return raisedException("Erreur de Token", url);
      }

      http.Response response =
          await http.post(url, body: data, headers: getHeaders(token));
      alice.onHttpResponse(response);

      final Map<String, dynamic> res = json.decode(response.body);
      print("resultat map is $res");

      if (response.statusCode != 200) {
        var msg = res['msg'] != null
            ? res['msg']
            : "${res['message']} ${res['description'] ?? ''}";
        return raisedException(msg, url);
      }
      return {"status": true, "msg": res};
    } catch (err) {
      return errorException(err);
    }
  }

  Future<Map> get_api(String url, [has_token = false]) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString(TOKEN);
      print("token is $has_token && $token");
      if (has_token && token == null) {
        return raisedException("Erreur de Token", url);
      }

      http.Response response =
          await http.get(url, headers: has_token ? getHeaders(token) : {});
      alice.onHttpResponse(response);
      var resultat;

      try {
        final Map<String, dynamic> res = json.decode(response.body);
        print("resultat map is $res");
        resultat = res;
      } catch (exc) {
        var res = json.decode(response.body);
        resultat = res;
      }

      print("resultat map is $resultat");

      if (response.statusCode != 200) {
        var msg = resultat['msg'] != null
            ? resultat['msg']
            : "${resultat['message']} ${resultat['description'] ?? ''}";
        return raisedException(msg, url);

        /* return raisedException(
            resultat.runtimeType != Map
                ? "Erreur reponse Http"
                : resultat['msg'],
            url);*/
      }

      return {"status": true, "msg": resultat};
    } catch (err) {
      return errorException(err);
    }
  }

  Future<dynamic> getMyExtIpInfo() async {
    var url = 'https://api.myip.com';
    try {
      http.Response response = await http.get(url);
      final Map<String, dynamic> res = json.decode(response.body);

      if (response.statusCode != 200) {
        return raisedException(res['msg'], url);
      }
      return {"status": true, "msg": res};
    } catch (err) {
      return errorException(err);
    }
  }

  Map<String, String> getHeaders(token) {
    return {'Accept': 'application/json', 'Authorization': "Bearer $token"};
  }

  Map<String, dynamic> errorException(err) {
    print("Error Exception :: ${err.toString()}");
    notifyListeners();
    return {"status": false};
  }

  Map<String, dynamic> raisedException(msg, url) {
    print('raised exception URL : $url');
    notifyListeners();
    return {"status": false, "msg": msg};
  }
}
