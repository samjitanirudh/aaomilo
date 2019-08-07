import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meetup_login/InviteList.dart';
import 'package:flutter_meetup_login/viewmodel/ProfileDataUpdate.dart';
import 'package:flutter_meetup_login/views/CreateInvite.dart';
import 'package:flutter_meetup_login/views/tabs/CategoriesTab.dart';
import 'package:flutter_meetup_login/views/tabs/MyInvites.dart';
import 'package:flutter_meetup_login/views/tabs/MyProfileTab.dart';
import 'package:flutter_meetup_login/views/tabs/NotificationTab.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class TabViewScreen extends StatefulWidget {
  final FirebaseAnalytics analytics;

  TabViewScreen({Key key, this.analytics}) : super(key: key);

  @override
  TabsState createState() => new TabsState(analytics);
}

// SingleTickerProviderStateMixin is used for animation
class TabsState extends State<TabViewScreen> with SingleTickerProviderStateMixin {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final FirebaseAnalytics analytics;
  // Create a tab controller
  TabController controller;
  int _selectedPage = 0;
  List<dynamic> pageOptions;
  TabsState(this.analytics);
  String _homeScreenText;
  @override
  void initState() {
    super.initState();
    _setCurrentScreen();
    // Initialize the Tab Controller
    controller = new TabController(length: 4, vsync: this);
    initFireBase();
  }

  Future<void> _setCurrentScreen() async {
    await analytics.setCurrentScreen(
      screenName: "Tab Screen",
      screenClassOverride: 'TableViewScreen',
    );
  }

  @override
  Widget build(BuildContext context) {
    pageOptions = [
      InviteList(analytics: analytics, selectedIndexList: null,),
      CreateInvite(),
      MyInvitesScreen(),
      MyProfile(userid: "",)
    ];
    return new Scaffold(
      // Appbar

      // Set the TabBar view as the body of the Scaffold
      body: pageOptions[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black45,currentIndex: _selectedPage, onTap: (int index) {
        setState(() {
          _selectedPage = index;
        });
      },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list), title: Text("Invite List"), backgroundColor: Color(0xff00334e)),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), title: Text("Create Invite"),backgroundColor: Color(0xff00334e)),
          BottomNavigationBarItem(icon: Icon(Icons.event_available), title: Text("My Events"),backgroundColor: Color(0xff00334e)),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), title: Text("My Profile"),backgroundColor: Color(0xff00334e)),

        ],
      ),

      // Add tabs as widgets


    );
  }

  void initFireBase() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                title: Text(message["notification"]["title"],style: new TextStyle(fontSize: 16),),
                content: Text(message["notification"]["body"]),
              );
            }
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        //print("onMessage: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        //print("onMessage: $message");
      },
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      _homeScreenText = token;
      ProfileDataModel().postFCMToken(token);
    });
  }
}