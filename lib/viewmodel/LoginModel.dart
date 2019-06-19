import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class LoginModel {
  var loginUrl = "https://reqres.in/api/users";
  static const platform = const MethodChannel('samples.flutter.dev/ssoanywhere');
  Future<String> checkLogin( String uname, String pass) {
    return _getAccessToken(uname,pass); // ignore: argument_type_not_assignable
  }

//  Future<String> post(String url, {Map headers, body, encoding}) {
//    return http
//        .post(url, body: body, headers: headers, encoding: encoding)
//        .then((http.Response response) {
//      final int statusCode = 100;//response.statusCode;
//      if (statusCode < 200 || statusCode > 400 || json == null) {
//        throw new Exception("Error while fetching data");
//      }
//      return response.body;
//    });
//  }
  Future<String> _getAccessToken( String uname, String pass) async {
    String accessToken;
    try {
      var parameters = new Map();
      parameters['username'] = uname;
      parameters['password'] = pass;
      final String result = await platform.invokeMethod('getAccessToken',{'credentials': parameters});

      accessToken = result;
    } on PlatformException catch (e) {
      accessToken = "Error : '${e.code}'.";
    }
    return accessToken;
  }
  LoginModel();
}
