import 'dart:convert';

import 'package:codedecoders/strings/const.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiScope extends Model {
  //**************************************
  Future<Map> post_noToken(Map data, String url) async {
    try {
      http.Response response = await http.post(url, body: data);
//      alice.onHttpResponse(response);

      final Map<String, dynamic> res = json.decode(response.body);
//      print("resultat map is $res");

      if (res.containsKey('msg')) {
        if (response.statusCode != 200) {
          return raisedException(res['msg'], url);
        }
        return {"status": true, "msg": res['msg'], "data": res};
      } else {
        return raisedException("Erreurr Inattendue", url);
      }
    } catch (err) {
      return errorException(err);
    }
  }

  Future<Map> post_token(Map data, String url) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString(TOKEN);
      if (token == null) {
        return raisedException("Erreur de Token", url);
      }

      http.Response response =
          await http.post(url, body: data, headers: getHeaders(token));
//      alice.onHttpResponse(response);

      final Map<String, dynamic> res = json.decode(response.body);
//      print("resultat map is $res");

      if (res.containsKey('msg')) {
        if (response.statusCode != 200) {
          return raisedException(res['msg'], url);
        }
        return {"status": true, "msg": res['msg'], "data": res};
      } else {
        return raisedException("Erreurr Inattendue", url);
      }
    } catch (err) {
      return errorException(err);
    }
  }

  Future<Map> get_token(String url) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString(TOKEN);
      if (token == null) {
        return raisedException("Erreur de Token", url);
      }

      http.Response response = await http.get(url, headers: getHeaders(token));
      //alice.onHttpResponse(response);

      final Map<String, dynamic> res = json.decode(response.body);
//      print("resultat map is $res");

      if (res.containsKey('msg')) {
        if (response.statusCode != 200) {
          return raisedException(res['msg'], url);
        }
        return {"status": true, "msg": res['msg'], "data": res};
      } else {
        return raisedException("Erreurr Inattendue", url);
      }
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
