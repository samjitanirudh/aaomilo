import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_meetup_login/utils/AppColors.dart';

class MyInvites extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return null;
  }

}

class MyInvitesState extends State<MyInvites>{

  BuildContext bContext;
  bool _isLoading;

  @override
  Widget build(BuildContext context) {
    bContext = context;
    return Scaffold(
        appBar: AppBar(
            backgroundColor: AppColors.PurpleVColor,
            title: Text("Invites"),
            textTheme: TextTheme(
                title: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                )),
            actions: <Widget>[
              new IconButton(
                icon: new Icon(Icons.filter_list),
                color: Colors.white,
                padding: EdgeInsets.all(20),
                onPressed: () {
                },
              ),
            ]),
        body: new Stack(
          children: <Widget>[
           // _isLoading ? loaderOnViewUpdate() : _buildSuggestions()
          ],
        ));
  }

  Widget loaderOnViewUpdate() {
    var modal = new Stack(
      children: [
        new Opacity(
          opacity: 0.3,
          child: const ModalBarrier(
              dismissible: false, color: AppColors.BackgroundColor),
        ),
        new Center(
          child: new CircularProgressIndicator(),
        ),
      ],
    );
    return modal;
  }

}