import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meetup_login/InviteList.dart';
import 'package:flutter_meetup_login/UpdateUserProfileScreen.dart';
import 'package:flutter_meetup_login/splash_screen.dart';
import 'package:flutter_meetup_login/utils/NotificationItemClass.dart';
import 'package:flutter_meetup_login/viewmodel/Categories.dart';
import 'package:flutter_meetup_login/viewmodel/Skills.dart';
import 'package:flutter_meetup_login/viewmodel/Venue.dart';
import 'package:flutter_meetup_login/views/tabViewScreen.dart';
import 'package:flutter_meetup_login/views/login_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  String _homeScreenText = "Waiting for token...";
  static FirebaseAnalytics analytics = FirebaseAnalytics();


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
        primaryColor: Color(0xffb74093)
      ),
      home: new SplashScreen(analytics: analytics,),
      routes: <String, WidgetBuilder>{
        '/Loginscreen': (BuildContext context) => new loginScreen(analytics: analytics,),
        '/UpdateUserProfileScreen': (BuildContext context) => new UpdateUserProfileScreen(analytics: analytics,),
        '/TabViewScreen': (BuildContext context) => new TabViewScreen(analytics: analytics,),
        '/InviteList':(BuildContext context) => new InviteList(analytics: analytics,selectedIndexList: null,)
      },
    );
  }
}

