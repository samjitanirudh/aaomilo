import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:flutter/services.dart';
import 'package:flutter_meetup_login/utils/AppStringClass.dart';
import 'package:http/http.dart' as http;

class LoginModel {

  static const platform = const MethodChannel('samples.flutter.dev/ssoanywhere');
  static int refreshCount=0;
  var usercheckAPI  = AppStringClass.APP_BASE_URL+"work/action.php?usercheck=";
  Map<String, String> headers = new Map();

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

  Future<String> checkUser(String token) {
    headers['Content-type']="application/x-www-form-urlencoded";
    headers['Authorization']="Berear "+token;
    var encoding = Encoding.getByName('utf-8');
    return checkUserExist(usercheckAPI,headers: headers,body: getPostParams(),encoding: encoding)
        .then((String res) {
      if (res == null) throw new Exception("error");
      else if(res=="sessionExpired")
        return res;
      else
        return res;
    });
  }


  Future<String> checkUserExist(String url, {Map headers,body, encoding}) {
    return http
        .post(url,body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      if ((statusCode < 200 || statusCode > 400 || json == null) || response.body=="") {
        throw new Exception("Error while fetching data");
      }else if(response.body == "token expired"){
        return "sessionExpired";
      }
      return response.body;
    });
  }

  String getPostParams(){
    String action='action=usercheck';
    return action;
  }
}
