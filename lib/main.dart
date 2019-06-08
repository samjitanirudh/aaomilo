import 'package:flutter/material.dart';
import 'package:flutter_meetup_login/UpdateUserProfileScreen.dart';
import 'package:flutter_meetup_login/splash_screen.dart';
import 'package:flutter_meetup_login/viewmodel/Categories.dart';
import 'package:flutter_meetup_login/viewmodel/Skills.dart';
import 'package:flutter_meetup_login/viewmodel/Venue.dart';
import 'package:flutter_meetup_login/views/CreateInvite.dart';
import 'package:flutter_meetup_login/views/tabViewScreen.dart';
import 'package:flutter_meetup_login/views/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  MyApp(){
    CategoryClass().categoryGetRequest();
    VenueClass().venueGetRequest();
    SkillClass().skillGetRequest();
  }

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
        '/UpdateUserProfile': (BuildContext context) => new UpdateUserProfileScreen(),
        '/TabViewScreen': (BuildContext context) => new TabViewScreen()
      },
    );
  }
}

