import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'viewmodel/ProfileDataUpdate.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const platform = const MethodChannel('samples.flutter.dev/ssoanywhere');
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
      Navigator.of(context).pushReplacementNamed('/TabViewScreen');
    }
    else
      Navigator.of(context).pushReplacementNamed('/Loginscreen');
  }


  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(

      body:  _splashScreen()

    );
  }
}

Widget _splashScreen() {

 return new Container(

      decoration: new BoxDecoration(
          color: const Color(0xff7c94b6),
          image: new DecorationImage(
            image: new ExactAssetImage('assets/images/splash_screen.png'),
            fit: BoxFit.cover,
          ),
      ));
 }