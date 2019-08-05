import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class LoginModel {

  static const platform = const MethodChannel('samples.flutter.dev/ssoanywhere');
  static int refreshCount=0;

  LoginModel();


  Future<String> checkLogin( String uname, String pass) {
    return _getAccessToken(uname,pass); // ignore: argument_type_not_assignable
  }

  Future<String> refreshToken() {
    return _getRefreshAccessToken(); // ignore: argument_type_not_assignable
  }

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

  Future<String> _getRefreshAccessToken() async {
    String accessToken;
    try {
      final String result = await platform.invokeMethod('getRefreshToken');
      accessToken = result;
    } on PlatformException catch (e) {
      accessToken = "Error : '${e.code}'.";
    }
    return accessToken;
  }


}
