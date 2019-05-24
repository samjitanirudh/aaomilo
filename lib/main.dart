import 'package:flutter/material.dart';
import 'package:flutter_meetup_login/skillSelection.dart';
import 'package:flutter_meetup_login/splash_screen.dart';
import 'package:flutter_meetup_login/views/CreateInvite.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SplashScreen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/Loginscreen': (BuildContext context) => new CreateInvite(),
        '/SkillSelection': (BuildContext context) => new SkillSelection()
      },
    );
  }
}

