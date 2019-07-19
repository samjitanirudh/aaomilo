import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meetup_login/InviteList.dart';
import 'package:flutter_meetup_login/UpdateUserProfileScreen.dart';
import 'package:flutter_meetup_login/splash_screen.dart';
import 'package:flutter_meetup_login/viewmodel/Categories.dart';
import 'package:flutter_meetup_login/viewmodel/Skills.dart';
import 'package:flutter_meetup_login/viewmodel/Venue.dart';
import 'package:flutter_meetup_login/views/tabViewScreen.dart';
import 'package:flutter_meetup_login/views/login_screen.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() {
  // Set `enableInDevMode` to true to see reports while in debug mode
  // This is only to be used for confirming that reports are being
  // submitted as expected. It is not intended to be used for everyday
  // development.
  Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors to Crashlytics.
  FlutterError.onError = (FlutterErrorDetails details) {
    Crashlytics.instance.onError(details);
  };
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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

