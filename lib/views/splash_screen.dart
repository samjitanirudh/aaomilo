import 'dart:async';
import 'dart:convert';
import 'package:flutter_meetup_login/utils/AppStringClass.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_meetup_login/utils/AppColors.dart';
import 'package:flutter_meetup_login/viewmodel/UserProfile.dart';


class SplashScreen extends StatefulWidget {

  final FirebaseAnalytics analytics;

  SplashScreen({Key key, this.analytics}) : super(key: key);

  @override
  _SplashScreenState createState() => new _SplashScreenState(analytics);
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAnalytics analytics;
  static const platform = const MethodChannel('samples.flutter.dev/ssoanywhere');
  var usercheckAPI  = AppStringClass.APP_BASE_URL+"work/action.php?action=usercheck";
  Map<String, String> headers = new Map();
  _SplashScreenState(this.analytics);

  startTime() async {
    var _duration = new Duration(seconds: 4);
    return new Timer(_duration, navigationPage);
  }
  Future<bool> _isLoggedIn() async {
    bool isLoggedIn=false;
    try {
      isLoggedIn = await platform.invokeMethod('isLoggedIn');

    } on PlatformException catch (e) {
      isLoggedIn =false;
    }
    return isLoggedIn;
  }

  Future navigationPage() async {
    bool response = await _isLoggedIn() as bool;
    if (response) {
      String user = await UserProfile().getInstance().getLoggedInUser();
      UserProfile().getInstance().setSGID(user);
      bool isNewUser =await newUser(user);
      if(isNewUser)
        Navigator.of(context).pushReplacementNamed('/UpdateUserProfileScreen');
      else
        Navigator.of(context).pushReplacementNamed('/TabViewScreen');
    }
    else
      Navigator.of(context).pushReplacementNamed('/Loginscreen');
  }

  Future<bool> newUser(String userToken) async{
    try{
      String response = await checkUser(userToken);

      if(response!=null && !response.contains("Error : ") && response.contains("new")) {
        return true;
      }
      else{
        return false;
      }
    }on Exception catch(error){
      return false;
    }
  }


  Future<void> _testSetCurrentScreen() async {
    await analytics.setCurrentScreen(
      screenName: "Splash Sreen",
      screenClassOverride: 'SplashSreen',
    );
    startTime();
  }

  @override
  void initState() {
    super.initState();
    _testSetCurrentScreen();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body:  _splashScreen(context)
    );
  }

  Widget _splashScreen(BuildContext context) {
    return new Container(
        width: MediaQuery.of(context).size.width,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Image.asset("assets/images/logoConverge.png"),
          ],
        ),
        decoration: new BoxDecoration(
            color: const Color(0xff7c94b6),
            gradient: new LinearGradient(
                colors: [
                  AppColors.PurpleVColor,
                  AppColors.lightPurple,
                ],
                stops: [0.0, 1.0],
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                tileMode: TileMode.repeated
            )
        )
    );
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



