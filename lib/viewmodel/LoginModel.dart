import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;

class LoginModel {
  var loginUrl = "https://reqres.in/api/users";

  Future<String> checkLogin(String uname, String pass) {
    return post(loginUrl, body: {'name': uname, 'movies': '[' + pass + ']'})
        .then((String res) {
      print(res.toString());
      if (res == null) throw new Exception("error");
      return res;
    });
  }

  Future<String> post(String url, {Map headers, body, encoding}) {
    return http
        .post(url, body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      final int statusCode = 100;//response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return response.body;
    });
  }

  LoginModel();
}
