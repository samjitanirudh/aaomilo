import 'package:flutter/material.dart';
import 'package:flutter_meetup_login/InviteList.dart';



import 'package:flutter_meetup_login/views/CreateInvite.dart';
import 'package:flutter_meetup_login/views/tabs/CategoriesTab.dart';


import 'package:flutter_meetup_login/views/tabs/MyInvites.dart';
import 'package:flutter_meetup_login/views/tabs/MyProfileTab.dart';
import 'package:flutter_meetup_login/views/tabs/NotificationTab.dart';



class TabViewScreen extends StatefulWidget {
  @override
  TabsState createState() => new TabsState();
}

// SingleTickerProviderStateMixin is used for animation
class TabsState extends State<TabViewScreen> with SingleTickerProviderStateMixin {
  // Create a tab controller
  TabController controller;
  int _selectedPage = 0;
  final pageOptions = [InviteList(null),  CreateInvite(), MyInvitesScreen(), MyProfile()
  ];

  @override
  void initState() {
    super.initState();

    // Initialize the Tab Controller
    controller = new TabController(length: 4, vsync: this);
  }

//  @override
//  void dispose() {
//    // Dispose of the Tab Controller
////    controller.dispose();
//    super.dispose();
//  }

  @override
  Widget build(BuildContext context) {
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
}