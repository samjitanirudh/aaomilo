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

  @override
  void initState() {
    super.initState();

    // Initialize the Tab Controller
    controller = new TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    // Dispose of the Tab Controller
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // Appbar

      // Set the TabBar view as the body of the Scaffold
      body: new TabBarView(
        // Add tabs as widgets
        children: <Widget>[new InviteList(), CategoriesTab(), new MyInvites(), new CreateInvite(), new NotificationTab(), new MyProfile()],
        // set the controller
        controller: controller,
      ),
      // Set the bottom navigation bar
      bottomNavigationBar: new Material(
        // set the color of the bottom navigation bar
        color: Colors.grey,
        // set the tab bar as the child of bottom navigation bar
        child: new TabBar(
          tabs: <Tab>[
            new Tab(
              icon: new Icon(Icons.list),
            ),
            new Tab(
              // set icon to the tab
              icon: new Icon(Icons.category),
            ),
            new Tab(
              icon: new Icon(Icons.event_available),
            ),
            new Tab(
              icon: new Icon(Icons.add_circle),
            ),
            new Tab(
              icon: new Icon(Icons.notifications),
            ),
            new Tab(
              icon: new Icon(Icons.account_circle),
            ),
          ],
          // setup the controller
          controller: controller,
        ),
      ),
    );
  }
}